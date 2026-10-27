
#!/usr/bin/env bash

set -euo pipefail



cd src/api

npm ci

npm test

