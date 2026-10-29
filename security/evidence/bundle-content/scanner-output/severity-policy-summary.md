# Normalized Scanner Severity Policy

**Policy:** scanner-severity-normalization

**Owner:** security-team

**Purpose:** Normalize scanner severities into consistent pull request decisions.

## Merge Decision Tiers

| Decision | Normalized Severities | Developer Meaning |
|---|---|---|
| Block | critical, high | Fix before merge or create a time-bound risk acceptance issue. |
| Warn | medium, low | Review before merge and link follow-up work if needed. |
| Info | informational, unknown | Recorded for evidence; no immediate action required. |

## Domain-Specific Rules

| Domain | Rule | Reason |
|---|---|---|
| Secrets | block_all_verified | A verified credential can expose cloud accounts, signing keys, build systems, or player data. |
| Containers | block_high_runtime_reachable | Container findings matter most when they exist in runtime packages or reachable service paths. |
| Dependencies | block_high_with_fix | Dependency gates should prioritize severe findings that have a safe upgrade path. |
| IaC | block_high_external_exposure | Infrastructure findings should block when they expose public access, privileged identity, or sensitive storage. |
| SAST | block_high_confidence_high_impact | Static analysis gates should balance impact, exploitability, and false-positive risk. |

## Exception Requirements

A blocked finding can only be accepted temporarily when the risk acceptance issue includes:

- finding_id
- scanner
- normalized_severity
- business_reason
- compensating_control
- owner
- expiry_date

**Maximum exception duration:** 30 days
