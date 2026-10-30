# Generated Scanner Evaluation Scorecard

Generated: 2026-10-30T07:43:18Z

## Decision Summary

| Tool | Category | Weighted Score | Decision | Owner |
|---|---|---:|---|---|
| Semgrep Community | SAST | 4.44 | Adopt / Standardize | Application Security |
| Trivy | Container and dependency scanning | 4.26 | Adopt / Standardize | Platform Security |
| OpenSSF Scorecard | Open-source project health | 3.80 | Pilot / Warn-only | Supply Chain Security |

## Semgrep Community

**Category:** SAST

**Source:** [https://github.com/semgrep/semgrep](https://github.com/semgrep/semgrep)

**Owner:** Application Security

**Decision:** Adopt / Standardize

**Weighted Score:** 4.44

### Criteria Scores

| Criterion | Weight | Score |
|---|---:|---:|
| Open-source usability | 0.12 | 5 |
| CI reliability | 0.16 | 4 |
| Signal quality | 0.20 | 4 |
| SARIF or artifact support | 0.12 | 4 |
| Policy control | 0.14 | 5 |
| Runtime cost | 0.08 | 4 |
| Maintenance health | 0.10 | 5 |
| Gaming relevance | 0.08 | 5 |

### Evidence

Already used for custom game-service rules, workflow rules, and client-authority checks.

### Decision Notes

Strong candidate for standard SAST and custom gaming-specific rules.


## Trivy

**Category:** Container and dependency scanning

**Source:** [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy)

**Owner:** Platform Security

**Decision:** Adopt / Standardize

**Weighted Score:** 4.26

### Criteria Scores

| Criterion | Weight | Score |
|---|---:|---:|
| Open-source usability | 0.12 | 5 |
| CI reliability | 0.16 | 4 |
| Signal quality | 0.20 | 4 |
| SARIF or artifact support | 0.12 | 5 |
| Policy control | 0.14 | 4 |
| Runtime cost | 0.08 | 3 |
| Maintenance health | 0.10 | 5 |
| Gaming relevance | 0.08 | 4 |

### Evidence

Useful for container image, filesystem, dependency, and configuration scanning.

### Decision Notes

Strong candidate for container and game-service artifact gates.


## OpenSSF Scorecard

**Category:** Open-source project health

**Source:** [https://github.com/ossf/scorecard](https://github.com/ossf/scorecard)

**Owner:** Supply Chain Security

**Decision:** Pilot / Warn-only

**Weighted Score:** 3.80

### Criteria Scores

| Criterion | Weight | Score |
|---|---:|---:|
| Open-source usability | 0.12 | 5 |
| CI reliability | 0.16 | 4 |
| Signal quality | 0.20 | 3 |
| SARIF or artifact support | 0.12 | 4 |
| Policy control | 0.14 | 3 |
| Runtime cost | 0.08 | 4 |
| Maintenance health | 0.10 | 5 |
| Gaming relevance | 0.08 | 3 |

### Evidence

Useful as a maintenance and security-health signal when evaluating open-source scanner projects.

### Decision Notes

Best used as supporting evidence, not as the only adoption decision.

