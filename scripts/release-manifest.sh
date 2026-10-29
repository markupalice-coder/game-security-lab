#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-game-api:lab56}"
SBOM_PATH="${2:-security/out/game-api.spdx.json}"
OUT_DIR="${OUT_DIR:-security/out}"

MANIFEST_JSON="$OUT_DIR/release-manifest.json"
MANIFEST_ENV="$OUT_DIR/release-manifest.env"
CHECKSUM_FILE="$OUT_DIR/release-checksums.sha256"

require_tool() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required tool: $1" >&2
    exit 10
  fi
}

sha256_file() {
  local file="$1"

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$file" | awk '{print $1}'
  else
    echo "Missing sha256sum or shasum" >&2
    exit 11
  fi
}

require_tool git
require_tool docker
require_tool jq

mkdir -p "$OUT_DIR"

if [[ ! -f "$SBOM_PATH" ]]; then
  echo "Missing SBOM: $SBOM_PATH" >&2
  echo "Fix: run Lab 57 again, or pass the SBOM path as the second argument." >&2
  exit 20
fi

if [[ ! -f "src/api/Dockerfile" ]]; then
  echo "Missing Dockerfile: src/api/Dockerfile" >&2
  echo "Fix: run this script from the game-security-lab repository root." >&2
  exit 21
fi

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Missing Docker image: $IMAGE" >&2
  echo "Fix: rebuild it with:" >&2
  echo "docker build -t game-api:lab56 src/api" >&2
  exit 30
fi

COMMIT="$(git rev-parse HEAD)"
SHORT_COMMIT="$(git rev-parse --short HEAD)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
BUILD_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

IMAGE_ID="$(docker image inspect "$IMAGE" --format '{{.Id}}')"

IMAGE_DIGESTS_JSON="$(
  docker image inspect "$IMAGE" --format '{{json .RepoDigests}}' |
  jq -c 'if type == "array" then . else [] end'
)"

PRIMARY_DIGEST="$(
  printf '%s\n' "$IMAGE_DIGESTS_JSON" |
  jq -r '.[0] // "local-image-not-pushed-yet"'
)"

SBOM_SHA256="$(sha256_file "$SBOM_PATH")"
DOCKERFILE_SHA256="$(sha256_file "src/api/Dockerfile")"

# Generate release manifest JSON
jq -n \
  --arg schema "game-studio.release-manifest.v1" \
  --arg generated_at "$BUILD_UTC" \
  --arg commit "$COMMIT" \
  --arg short_commit "$SHORT_COMMIT" \
  --arg branch "$BRANCH" \
  --arg image "$IMAGE" \
  --arg image_id "$IMAGE_ID" \
  --arg primary_digest "$PRIMARY_DIGEST" \
  --argjson repo_digests "$IMAGE_DIGESTS_JSON" \
  --arg sbom_path "$SBOM_PATH" \
  --arg sbom_format "SPDX JSON" \
  --arg sbom_sha256 "$SBOM_SHA256" \
  --arg dockerfile_path "src/api/Dockerfile" \
  --arg dockerfile_sha256 "$DOCKERFILE_SHA256" \
  '{
    schema: $schema,
    generated_at: $generated_at,
    source: {
      commit: $commit,
      short_commit: $short_commit,
      branch: $branch
    },
    artifact: {
      type: "container-image",
      name: "game-api",
      image_reference: $image,
      image_id: $image_id,
      primary_digest: $primary_digest,
      repo_digests: $repo_digests
    },
    sbom: {
      path: $sbom_path,
      format: $sbom_format,
      sha256: $sbom_sha256
    },
    build_inputs: {
      dockerfile: {
        path: $dockerfile_path,
        sha256: $dockerfile_sha256
      }
    },
    verification: {
      previous_lab: "Lab 59. Add Image Digest Discipline",
      current_lab: "Lab 60. Build a Release Artifact Manifest",
      rollback_ref: "lab60-start"
    }
  }' > "$MANIFEST_JSON"

# Generate release environment metadata
cat > "$MANIFEST_ENV" <<ENVEOF
COMMIT=$COMMIT
SHORT_COMMIT=$SHORT_COMMIT
BRANCH=$BRANCH
IMAGE=$IMAGE
IMAGE_ID=$IMAGE_ID
PRIMARY_DIGEST=$PRIMARY_DIGEST
SBOM_PATH=$SBOM_PATH
SBOM_SHA256=$SBOM_SHA256
BUILT_AT_UTC=$BUILD_UTC
ENVEOF

# Generate SHA256 checksums
MANIFEST_JSON_SHA256="$(sha256_file "$MANIFEST_JSON")"
MANIFEST_ENV_SHA256="$(sha256_file "$MANIFEST_ENV")"

{
  printf '%s  %s\n' "$SBOM_SHA256" "$SBOM_PATH"
  printf '%s  %s\n' "$DOCKERFILE_SHA256" "src/api/Dockerfile"
  printf '%s  %s\n' "$MANIFEST_JSON_SHA256" "$MANIFEST_JSON"
  printf '%s  %s\n' "$MANIFEST_ENV_SHA256" "$MANIFEST_ENV"
} > "$CHECKSUM_FILE"

echo "Release manifest generated successfully:"
echo "$MANIFEST_JSON"
echo "$MANIFEST_ENV"
echo "$CHECKSUM_FILE"
