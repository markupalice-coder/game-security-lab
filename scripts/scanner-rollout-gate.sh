#!/usr/bin/env bash
set -euo pipefail
POLICY_FILE="${POLICY_FILE:-security/severity-policy.yml}"
SCANNER_NAME="${SCANNER_NAME:-experimental-scanner}"
SCANNER_EXIT_CODE="${SCANNER_EXIT_CODE:-0}"
REPORT_FILE="security/out/${SCANNER_NAME}-rollout.md"

if [[ ! -f "$POLICY_FILE" ]]; then
echo "::error title=Policy file missing::Cannot find $POLICY_FILE"
exit 2
fi

ROLLOUT_MODE="$(
awk -F': *' '/new_scanner_mode:/ {print $2; exit}' "$POLICY_FILE" \
| tr -d '"' \
| xargs
)"

PROMOTION_RULE="$(
awk -F': *' '/promotion_requires:/ {print $2; exit}' "$POLICY_FILE" \
| tr -d '"' \
| xargs
)"

mkdir -p "$(dirname "$REPORT_FILE")"

{
echo "# Scanner Rollout Report"
echo
echo "- Scanner: $SCANNER_NAME"
echo "- Rollout mode: ${ROLLOUT_MODE:-unset}"
echo "- Promotion requirement: ${PROMOTION_RULE:-unset}"
echo "- Scanner exit code observed: $SCANNER_EXIT_CODE"
echo "- Generated UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$REPORT_FILE"

if [[ "$SCANNER_EXIT_CODE" != "0" ]]; then
if [[ "$ROLLOUT_MODE" == "warn_only_first_two_weeks" ]]; then
echo "::warning title=${SCANNER_NAME} warn-only rollout::Scanner reported findings, but policy is warn-only. Review $REPORT_FILE before promotion."
echo "Warn-only scanner finding recorded in $REPORT_FILE"
exit 0
fi

echo "::error title=${SCANNER_NAME} blocking rollout::Scanner reported findings and rollout mode is blocking."
exit "$SCANNER_EXIT_CODE"
fi

echo "Scanner completed without findings."
