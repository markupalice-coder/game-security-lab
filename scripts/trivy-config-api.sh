
#!/usr/bin/env bash

set -euo pipefail



TARGET="${1:-src/api}"



mkdir -p security/out



docker run --rm \

-v "$PWD:/repo" \

-w /repo \

aquasec/trivy:latest config \

--severity HIGH,CRITICAL \

--exit-code 1 \

--format table \

"$TARGET" | tee security/out/trivy-config-api.txt

