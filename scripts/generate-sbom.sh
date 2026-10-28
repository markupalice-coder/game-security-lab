#!/usr/bin/env bash
set -euo pipefail

SYFT_IMAGE="${SYFT_IMAGE:-anchore/syft:v1.45.1}"
SBOM_OUTPUT="${SBOM_OUTPUT:-security/out/repo-sbom.cdx.json}"

mkdir -p "$(dirname "$SBOM_OUTPUT")"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) HOST_DIR="$(pwd -W)" ;;
  *) HOST_DIR="$(pwd -P)" ;;
esac

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$HOST_DIR:/work" \
  -w /work \
  "$SYFT_IMAGE" \
  dir:/work \
  -o "cyclonedx-json=/work/$SBOM_OUTPUT"

echo "SBOM generated at: $SBOM_OUTPUT"
