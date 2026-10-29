#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-game-api:lab56}"
OUT_FILE="${2:-security/out/image-digest.env}"

mkdir -p "$(dirname "$OUT_FILE")"

REPO_DIGESTS="$(docker image inspect "$IMAGE" --format '{{json .RepoDigests}}')"

DIGEST_REF="$(
py -3.12 - "$REPO_DIGESTS" <<'PY'
import json
import sys

raw = sys.argv[1]

try:
    values = json.loads(raw)
except json.JSONDecodeError:
    values = []

if not values:
    print("")
else:
    print(values[0])
PY
)"

if [[ -z "$DIGEST_REF" || "$DIGEST_REF" == "null" ]]; then
    echo "ERROR: No RepoDigest found for image: $IMAGE" >&2
    echo "FIX: Push the image to a registry, then pull or inspect the registry-tagged image." >&2
    exit 1
fi

DIGEST="${DIGEST_REF##*@}"

{
    echo "IMAGE_TAG=$IMAGE"
    echo "IMAGE_DIGEST=$DIGEST"
    echo "PINNED_IMAGE=$DIGEST_REF"
    echo "CAPTURED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "SOURCE_COMMIT=$(git rev-parse HEAD)"
} > "$OUT_FILE"

echo "Pinned image reference:"
echo "$DIGEST_REF"
echo
echo "Digest evidence written to:"
echo "$OUT_FILE"
