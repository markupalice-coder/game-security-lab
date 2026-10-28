
#!/usr/bin/env bash

set -euo pipefail



INVENTORY_FILE="security/secret-inventory.md"



if [[ ! -f "$INVENTORY_FILE" ]]; then

echo "FAIL: $INVENTORY_FILE does not exist."

exit 1

fi



if grep -Eiq '\|[[:space:]]*(value|secret value|password)[[:space:]]*\|' "$INVENTORY_FILE"; then

echo "FAIL: Inventory contains a forbidden value/password-style column."

exit 1

fi



if grep -En '(AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]+|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]+)' "$INVENTORY_FILE"; then

echo "FAIL: Inventory appears to contain a secret-like value."

exit 1

fi



if ! grep -q '| Secret Name | Storage Scope | Owner | Rotation Cadence | Replacement Pattern | Used By | Evidence | Notes |' "$INVENTORY_FILE"; then

echo "FAIL: Inventory table header is missing or has been changed unexpectedly."

exit 1

fi



echo "PASS: Secret inventory exists, has the expected metadata columns, and contains no obvious secret values."

