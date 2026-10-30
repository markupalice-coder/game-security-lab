#!/usr/bin/env bash
set -euo pipefail

mkdir -p security/out

{
echo "# Capstone Audit Report"
echo
echo "Generated UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo
echo "## Git"
echo
echo "- Commit: $(git rev-parse HEAD)"
echo "- Branch: $(git rev-parse --abbrev-ref HEAD)"
echo
echo "## Workflow Files"
echo
find .github/workflows -maxdepth 1 -type f | sort | sed 's#^#- #'
echo
echo "## Security Files"
echo
find security -maxdepth 2 -type f | sort | sed 's#^#- #'
echo
echo "## Script Files"
echo
find scripts -maxdepth 1 -type f | sort | sed 's#^#- #'
echo
echo "## Capstone Files"
echo
find capstone -maxdepth 1 -type f | sort | sed 's#^#- #'
} > security/out/capstone-audit-report.md

echo "Capstone audit report written to security/out/capstone-audit-report.md"
