# Full Security Control Review

Generated: 2026-10-30T06:00:04Z

Branch: lab90-full-security-control-review

Commit: a41cdb3c79c0bcbf2c659450ea04aa54a050d968

## Control Files

- PASS: security/control-register.md exists
- PASS: security/severity-policy.yml exists
- PASS: security/vulnerability-sla.yml exists
- PASS: security/sarif-retention.md exists
- PASS: security/remediation-guide.md exists
- PASS: security/control-review-checklist.md exists

## Required Scripts

- WARN: scripts/test-api.sh exists but is not executable
- PASS: scripts/generate-sbom.sh exists and is executable
- PASS: scripts/scan-sbom.sh exists and is executable
- PASS: scripts/checkov.sh exists and is executable
- PASS: scripts/evidence-bundle.sh exists and is executable

## Evidence Outputs

- PASS: security/evidence-bundle.tgz exists
- PASS: security/out directory exists

## Release Review Decision

Decision: REVIEW_REQUIRED

Reason: Lab 90 produces evidence. A human reviewer must still inspect scanner output, exceptions, and release risk.
