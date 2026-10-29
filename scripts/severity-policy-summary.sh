#!/usr/bin/env bash
set -euo pipefail

POLICY_FILE="security/severity-policy.yml"
OUTPUT_FILE="security/out/severity-policy-summary.md"

mkdir -p security/out

YQ_IMAGE="mikefarah/yq:4"

read_yaml() {
  MSYS_NO_PATHCONV=1 docker run --rm -v "$PWD:/work" -w /work "$YQ_IMAGE" eval "$1" "$POLICY_FILE"
}

POLICY_NAME="$(read_yaml '.policy_name')"
OWNER="$(read_yaml '.owner')"
PURPOSE="$(read_yaml '.purpose')"

{
  echo "# Normalized Scanner Severity Policy"
  echo
  echo "**Policy:** ${POLICY_NAME}"
  echo
  echo "**Owner:** ${OWNER}"
  echo
  echo "**Purpose:** ${PURPOSE}"
  echo
  echo "## Merge Decision Tiers"
  echo
  echo "| Decision | Normalized Severities | Developer Meaning |"
  echo "|---|---|---|"
  echo "| Block | $(read_yaml '.decision_tiers.block.normalized_severities | join(", ")') | $(read_yaml '.developer_message.block') |"
  echo "| Warn | $(read_yaml '.decision_tiers.warn.normalized_severities | join(", ")') | $(read_yaml '.developer_message.warn') |"
  echo "| Info | $(read_yaml '.decision_tiers.info.normalized_severities | join(", ")') | $(read_yaml '.developer_message.info') |"
  echo
  echo "## Domain-Specific Rules"
  echo
  echo "| Domain | Rule | Reason |"
  echo "|---|---|---|"
  echo "| Secrets | $(read_yaml '.domain_rules.secrets.rule') | $(read_yaml '.domain_rules.secrets.reason') |"
  echo "| Containers | $(read_yaml '.domain_rules.containers.rule') | $(read_yaml '.domain_rules.containers.reason') |"
  echo "| Dependencies | $(read_yaml '.domain_rules.dependencies.rule') | $(read_yaml '.domain_rules.dependencies.reason') |"
  echo "| IaC | $(read_yaml '.domain_rules.iac.rule') | $(read_yaml '.domain_rules.iac.reason') |"
  echo "| SAST | $(read_yaml '.domain_rules.sast.rule') | $(read_yaml '.domain_rules.sast.reason') |"
  echo
  echo "## Exception Requirements"
  echo
  echo "A blocked finding can only be accepted temporarily when the risk acceptance issue includes:"
  echo
  read_yaml '.exception_requirements.required_fields[]' | sed 's/^/- /'
  echo
  echo "**Maximum exception duration:** $(read_yaml '.exception_requirements.maximum_duration_days') days"
} > "$OUTPUT_FILE"

if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  cat "$OUTPUT_FILE" >> "$GITHUB_STEP_SUMMARY"
fi

echo "Severity policy summary written to ${OUTPUT_FILE}"
