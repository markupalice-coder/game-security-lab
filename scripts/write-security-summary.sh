#!/usr/bin/env bash
set -euo pipefail

mkdir -p security/out

SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-security/out/lab82-security-summary.md}"

SAST_RESULT="${SAST_RESULT:-not-run}"
SECRETS_RESULT="${SECRETS_RESULT:-tracked-by-dedicated-workflow}"
DEPENDENCIES_RESULT="${DEPENDENCIES_RESULT:-tracked-by-dedicated-workflow}"
CONTAINERS_RESULT="${CONTAINERS_RESULT:-tracked-by-dedicated-workflow}"
IAC_RESULT="${IAC_RESULT:-tracked-by-dedicated-workflow}"

SERVER_URL="${GITHUB_SERVER_URL:-https://github.com}"
REPOSITORY="${GITHUB_REPOSITORY:-local/game-security-lab}"
RUN_ID="${GITHUB_RUN_ID:-local-run}"
COMMIT_SHA="${GITHUB_SHA:-$(git rev-parse HEAD 2>/dev/null || echo local)}"

RUN_URL="${SERVER_URL}/${REPOSITORY}/actions/runs/${RUN_ID}"
SHORT_SHA="${COMMIT_SHA:0:12}"

{
echo "## Security Summary"
echo
echo "**Repository:** ${REPOSITORY}"
echo
echo "**Commit:** \`${SHORT_SHA}\`"
echo
echo "**Workflow Run:** ${RUN_URL}"
echo
echo "| Control Family | Current Signal | Developer Action |"
echo "|---|---|---|"
echo "| SAST | ${SAST_RESULT} | Review CodeQL and Semgrep findings if this is not \`success\`. |"
echo "| Secrets | ${SECRETS_RESULT} | Check Gitleaks output before merging. Rotate immediately if a real secret appears. |"
echo "| Dependencies | ${DEPENDENCIES_RESULT} | Review OSV, npm audit, dependency review, Syft, and Grype signals. |"
echo "| Containers | ${CONTAINERS_RESULT} | Review Trivy image and configuration findings before deployment. |"
echo "| IaC and Policy | ${IAC_RESULT} | Review Checkov, Conftest, and policy-as-code outputs before infrastructure changes. |"
echo
echo "### Release Decision Hint"
echo
echo "- Merge only when required checks pass or documented exceptions exist."
echo "- Do not paste secrets, tokens, private keys, or raw credentials into summaries."
echo "- Treat this summary as a fast navigation panel, not as the final audit archive."
} >> "${SUMMARY_FILE}"

echo "Security summary written to ${SUMMARY_FILE}"
