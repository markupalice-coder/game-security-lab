
#!/usr/bin/env bash

set -euo pipefail



cd "$(dirname "${BASH_SOURCE[0]}")/../src/api"



echo "Running npm audit for the game API..."

npm audit --audit-level=high

