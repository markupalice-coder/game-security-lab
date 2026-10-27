
#!/usr/bin/env bash

set -euo pipefail



docker run --rm \

-v "$PWD:/repo:ro" \

-w /repo \

rhysd/actionlint:latest \

-color

