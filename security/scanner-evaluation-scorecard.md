
# Scanner Evaluation Scorecard



## Purpose



This scorecard prevents random scanner sprawl. A scanner should be adopted only when it produces useful security signal, works reliably in CI, creates usable evidence, and fits gaming-studio risks.



## Scoring Scale



| Score | Meaning |

|---:|---|

| 1 | Poor fit. High risk, weak evidence, or not usable in the current stack. |

| 2 | Weak fit. Some value, but major reliability, noise, or maintenance concerns. |

| 3 | Acceptable for experiment or warn-only use. |

| 4 | Strong fit. Suitable for gated CI after tuning. |

| 5 | Excellent fit. Production-ready and strategically valuable. |



## Decision Rules



| Weighted Score | Decision |

|---:|---|

| 4.0 to 5.0 | Adopt or standardize after owner approval. |

| 3.2 to 3.9 | Pilot in warn-only mode. |

| Below 3.2 | Reject or re-evaluate later. |



## Evaluation Criteria



| Criterion | Score 1-5 | Required Evidence | Notes |

|---|---:|---|---|

| Open-source usability | | License, install path, local usage, no forced vendor lock-in | |

| CI reliability | | GitHub Actions run time, deterministic exit codes, failure behavior | |

| Signal quality | | Useful findings, low false positives, actionable remediation | |

| SARIF or artifact support | | SARIF, JSON, Markdown, or artifact output | |

| Policy control | | Severity thresholds, allowlists, suppressions, config-as-code | |

| Runtime cost | | CI minutes, cache behavior, network dependency, developer friction | |

| Maintenance health | | Release activity, issue activity, security policy, OpenSSF Scorecard where applicable | |

| Gaming relevance | | Applies to game APIs, clients, build artifacts, live-ops, telemetry, anti-cheat-sensitive areas | |



## Required Adoption Evidence



Every proposed scanner must include:



1. Tool name and category.

2. Repository or vendor source.

3. License and usage model.

4. Example command.

5. Example output.

6. False-positive risk.

7. Rollout plan.

8. Owner.

9. Expiry date for pilot mode.

10. Final decision.

