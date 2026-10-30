
# Lab 100 Release Decision



## Release Candidate



- Branch: lab100-capstone

- Target branch: main

- Release type: Capstone demonstration

- Service: Game API

- Environment: Protected production design

- Region model: Sovereign release checklist required



## Required Evidence



| Evidence | Expected Location | Status |

|---|---|---|

| Pull request checks | GitHub PR checks | Pending |

| Unit test logs | GitHub Actions logs | Pending |

| SAST results | Code scanning and workflow logs | Pending |

| Secrets scan | Gitleaks workflow logs | Pending |

| Dependency scan | OSV, dependency review, npm audit, Grype | Pending |

| SBOM | security/out/repo-sbom.cdx.json | Pending |

| Container scan | Trivy SARIF and logs | Pending |

| IaC scan | Checkov logs | Pending |

| Policy-as-code | OPA or Conftest logs | Pending |

| Evidence bundle | security/out or uploaded artifact | Pending |

| Rollback point | capstone-start tag | Complete |

| Sovereign checklist | security/sovereign-release-checklist.md | Pending |



## Decision



Decision: Pending



Choose one final value after reviewing the PR:



- Approved

- Blocked

- Approved with time-bound risk acceptance



## Risk Acceptance



If any finding is accepted temporarily, record:



- Finding:

- Severity:

- Owner:

- Business reason:

- Compensating control:

- Expiry date:

- Evidence link:



## Rollback Plan



Rollback command:



git reset --hard capstone-start



## Final Reviewer Notes



Document whether the release control plane is ready for portfolio demonstration and what would be required before real production use.

