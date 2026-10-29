#!/usr/bin/env bash

set -euo pipefail

IMAGE="${1:-game-api:lab56}"
OUTPUT="${2:-security/out/game-api.spdx.json}"

mkdir -p "$(dirname "$OUTPUT")"

MSYS_NO_PATHCONV=1 docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd -W):/work" \
  anchore/syft:latest \
  "docker:$IMAGE" \
  -o "spdx-json=/work/$OUTPUT"

py -3.12 -m json.tool "$OUTPUT" >/dev/null

echo "SBOM written to $OUTPUT"
