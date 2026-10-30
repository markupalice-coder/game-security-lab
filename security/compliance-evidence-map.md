
# Compliance Evidence Map



## Purpose



This document maps high-level compliance and governance expectations to concrete engineering evidence in the gaming DevSecOps repository.



Compliance is treated as engineering evidence, not screenshots collected at the end of a release.



## Evidence Status Key



| Status | Meaning |

|---|---|

| Implemented | The artifact exists and is part of the current repository. |

| Generated | The artifact is produced by a script or workflow. |

| Implemented or planned | The artifact should exist by this stage or be explicitly tracked as planned. |

| Missing | The artifact is required but not yet present. |



## Executive Summary



| Expectation | Engineering Evidence | Why It Matters |

|---|---|---|

| Secure development | Branch protection, CODEOWNERS, SAST, review workflows, control register | Prevents unsafe code and workflow changes from reaching the protected branch. |

| Data protection by design | Data classification, telemetry minimization, SARIF retention, log retention | Helps ensure player data and security logs are intentionally collected, minimized, and retained. |

| Operational resilience | CI gates, rollback plans, evidence bundle, incident runbooks, runtime detection design | Helps the studio recover from failed releases, security events, and operational incidents. |

| Supply-chain control | SBOMs, dependency review, provenance design, signed artifact design, image digest discipline | Helps prove what was built, from which source, with which dependencies. |

| Third-party risk | Scanner scorecard, dependency updates, license policy, action allowlisting | Reduces risk from external actions, scanners, packages, and vendors. |

| Incident readiness | Secret rotation runbook, triage labels, vulnerability SLA, runtime detection design | Converts incidents from panic into a repeatable response process. |

| AI workflow governance | AI workflow safety rules, workflow threat model, human approval requirements | Prevents agentic automation from bypassing trust boundaries. |



## Detailed Evidence Map



### 1. Secure Development



| Evidence | Repository Location | Expected State |

|---|---|---|

| Control register | `security/control-register.md` | Implemented |

| CODEOWNERS | `.github/CODEOWNERS` | Implemented or planned |

| CodeQL workflow | `.github/workflows/codeql.yml` | Implemented or planned |

| Semgrep workflow | `.github/workflows/semgrep.yml` | Implemented or planned |

| Branch protection | GitHub **Settings** > **Branches** | Enabled manually in GitHub |



### 2. Data Protection by Design



| Evidence | Repository Location | Expected State |

|---|---|---|

| Data classification | `security/data-classification.md` | Implemented or planned |

| Telemetry minimization | `security/telemetry-minimization.md` | Implemented or planned |

| SARIF retention strategy | `security/sarif-retention-strategy.md` | Implemented or planned |

| AI log retention boundary | `security/ai-workflow-safety.md` | Implemented |



### 3. Operational Resilience



| Evidence | Repository Location | Expected State |

|---|---|---|

| API test script | `scripts/test-api.sh` | Implemented |

| Evidence bundle script | `scripts/evidence-bundle.sh` | Implemented |

| Evidence bundle output | `security/evidence-bundle.tgz` | Generated |

| Runtime detection design | `security/runtime-detection-design.md` | Implemented or planned |

| Incident runbook | `security/incident-runbook.md` | Implemented or planned |



### 4. Supply-Chain Control



| Evidence | Repository Location | Expected State |

|---|---|---|

| Repository SBOM | `security/out/repo-sbom.cdx.json` | Generated or planned |

| Container SBOM | `security/out/game-api.spdx.json` | Generated or planned |

| Dependency review workflow | `.github/workflows/dependency-review.yml` | Implemented or planned |

| Cosign signing design | `security/cosign-design.md` | Implemented or planned |

| SLSA provenance design | `security/slsa-design.md` | Implemented or planned |

| Image digest helper | `scripts/image-digest.sh` | Implemented or planned |



### 5. Third-Party Risk



| Evidence | Repository Location | Expected State |

|---|---|---|

| Scanner evaluation scorecard | `security/scanner-evaluation-scorecard.md` | Implemented |

| License policy | `security/license-policy.yml` | Implemented or planned |

| Dependabot config | `.github/dependabot.yml` | Implemented or planned |

| GitHub Actions vendor review | GitHub **Settings** > **Actions** > **General** | Configured manually |



### 6. Incident Readiness



| Evidence | Repository Location | Expected State |

|---|---|---|

| Secret rotation runbook | `security/secret-rotation-runbook.md` | Implemented or planned |

| Vulnerability SLA | `security/vulnerability-sla.yml` | Implemented or planned |

| Risk acceptance template | `.github/ISSUE_TEMPLATE/security-risk-acceptance.md` | Implemented or planned |

| Runtime detection design | `security/runtime-detection-design.md` | Implemented or planned |



### 7. AI Workflow Governance



| Evidence | Repository Location | Expected State |

|---|---|---|

| AI workflow safety rules | `security/ai-workflow-safety.md` | Implemented |

| Workflow threat model | `security/workflow-threat-model.md` | Implemented or planned |

| Human review requirement | Branch protection and CODEOWNERS | Enabled manually in GitHub |



## Release Decision Rule



A release is not compliance-ready unless:



1. Required security workflows have run.

2. Critical and high findings meet the vulnerability SLA.

3. Secrets are not exposed in repository history or artifacts.

4. SBOM evidence is generated or an exception is documented.

5. AI-assisted changes are reviewed by a human.

6. The evidence bundle includes the compliance evidence map.

7. Missing evidence is marked as planned, owned, and time-bound.



## Review Questions for Security Leads



1. Is every expectation tied to at least one engineering artifact?

2. Are any artifacts missing without an owner?

3. Are generated artifacts retained outside the developer laptop?

4. Are exceptions time-bound?

5. Can a non-technical reviewer understand the release risk?

