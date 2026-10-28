
#!/usr/bin/env bash

set -euo pipefail



echo "Secret Rotation Audit"

echo "====================="



if [[ -f "security/secret-rotation-runbook.md" ]]; then

echo "PASS: rotation runbook exists"

else

echo "FAIL: rotation runbook is missing"

exit 1

fi



if [[ -f "security/secret-rotation-drill.md" ]]; then

echo "PASS: rotation drill exists"

else

echo "FAIL: rotation drill is missing"

exit 1

fi



if [[ -f ".github/ISSUE_TEMPLATE/secret-rotation.md" ]]; then

echo "PASS: GitHub issue template exists"

else

echo "FAIL: GitHub issue template is missing"

exit 1

fi



if grep -R -n -I -E "AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9_]{20,}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----" security .github scripts --exclude="fake-secret-test.txt"; then

echo "FAIL: possible real secret pattern found"

exit 1

else

echo "PASS: no obvious real secret pattern found in Lab 35 files"

fi



if [[ -f ".gitleaks.toml" ]]; then

echo "PASS: Gitleaks config exists"

else

echo "WARN: .gitleaks.toml missing; Lab 34 may not be complete"

fi



echo "Audit complete"

