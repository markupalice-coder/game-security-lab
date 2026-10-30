# Security Evidence Bundle Manifest

Generated UTC: 2026-10-30T08:02:27Z

Git Commit: c6fbf5418085bd9651065e2e8208693044c6090e

Git Branch: lab96-ai-assisted-workflow-safety

Repository Root: E:/USR-Space/devsecops-gaming/game-security-lab

## Purpose

This bundle preserves security evidence for release reviews, audits,
incident reviews, scanner rollout governance, and security control reviews.

## Contents

- Control register and control review checklist, if available
- Severity policy and vulnerability SLA documentation, if available
- SARIF retention and remediation documentation, if available
- Player data classification Markdown policy, if available
- Player data classification JSON policy, if available
- Player data classification validation script, if available
- Telemetry privacy rules and rejected policy test fixtures, if available
- Telemetry privacy Rego policy and validation script, if available
- Security orchestrator and control review workflows, if available
- Telemetry privacy workflow, if available
- Kubernetes API deployment configuration, if available
- Evidence generation script, if available
- scanner-output/, including available SARIF and scanner reports
- security/reports/, if available
- SHA256SUMS
- evidence-manifest.md

## Integrity Verification

From the extracted bundle-content directory, run:

`sha256sum -c SHA256SUMS`

## Artifact Retention

The CI workflow uploads the generated archive as a GitHub Actions
security evidence artifact with a configured retention period of 30 days.
