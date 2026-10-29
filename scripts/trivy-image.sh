#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-game-api:lab51}"
TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.71.1}"

echo "Scanning container image: $IMAGE_NAME"
echo "Using scanner image: $TRIVY_IMAGE"

MSYS_NO_PATHCONV=1 docker run --rm -v /var/run/docker.sock:/var/run/docker.sock "$TRIVY_IMAGE" image "$IMAGE_NAME"
