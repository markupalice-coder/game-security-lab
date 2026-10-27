
#!/usr/bin/env bash

set -euo pipefail



echo "GitHub Actions external usage inventory"

echo "======================================="

echo



if [ ! -d ".github/workflows" ]; then

echo "No .github/workflows directory found."

exit 0

fi



grep -R "uses:" .github/workflows | sort || true



echo

echo "Review rule:"

echo "- GitHub-owned actions are allowed for this lab."

echo "- New third-party actions require documented approval."

echo "- Docker images in run steps are outside this action policy and must be tracked separately."

