
# Decentralized Threat Research Intake Governance



## Purpose



The Threat Research Intake process allows anyone on the studio team to propose new threats, scanners, rules, detections, and controls without directly changing production gates.



## Why This Exists



Security research moves faster than release pipelines. This process captures new ideas while preventing random tool sprawl, noisy scanners, unreviewed blocking rules, and undocumented compliance changes.



## Intake Rules



1. Every proposal must include evidence.

2. Every proposal must identify affected assets.

3. Every proposal must estimate false-positive risk.

4. Every proposal must include a safe rollout plan.

5. Sensitive vulnerability reports must not be filed through public issues.

6. New controls should normally start in documentation-only, local-only, or CI warn-only mode.



## Review Flow



1. Intake issue is created with the Threat Research Intake form.

2. Security reviewer checks evidence quality.

3. Platform reviewer checks CI/CD and developer-experience impact.

4. Data or regional owner checks sovereignty impact when needed.

5. Accepted proposals move to Lab 95 scanner evaluation.

6. Rejected proposals receive a reason and are closed.

7. High-potential proposals receive an implementation issue or pull request.



## Decision States



| State | Meaning |

|---|---|

| Needs Evidence | Submission is too vague to evaluate. |

| Research Accepted | Proposal is worth evaluation. |

| Warn-Only Candidate | Proposal should be tested without blocking releases. |

| Blocking Candidate | Proposal may become a required gate after evaluation. |

| Rejected | Proposal is not useful, safe, relevant, or maintainable. |



## Minimum Evidence Standard



Acceptable evidence includes:



- Official scanner documentation.

- Public vulnerability advisory.

- CVE or GHSA reference.

- Internal incident report without secrets or personal data.

- Reproducible test case using safe sample data.

- Security research write-up from a credible source.



## Gaming-Specific Review Questions



- Could this affect game economy integrity?

- Could this expose player data or telemetry?

- Could this leak signing keys, anti-cheat secrets, cloud roles, or store upload tokens?

- Could this break live-ops release speed?

- Could this create alert fatigue for developers?

- Could this require regional handling based on the sovereign deployment matrix?



## Promotion Rule



No new scanner or detection should become a blocking release gate until it has passed evaluation for signal quality, runtime cost, maintainability, evidence value, and developer impact.

