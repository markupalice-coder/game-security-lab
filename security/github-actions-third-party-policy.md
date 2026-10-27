
# GitHub Actions Third-Party Policy



## Purpose



This policy controls which external GitHub Actions and reusable workflows are allowed to run in this repository.



## Baseline Rule



Only approved workflow components may run.



## Current Approved Categories



| Category | Status | Reason |

|---|---|---|

| Local actions in this repository | Allowed | Controlled by this repository's review process |

| GitHub-owned actions from actions/* and github/* | Allowed | Required for standard CI building blocks |

| Marketplace actions from verified creators | Not blanket-allowed | Verification is useful but not enough for automatic trust |

| Unverified third-party actions | Blocked by default | Must be reviewed before use |

| Reusable workflows from outside this repository | Blocked by default | Must be reviewed before use |

| Docker images called from run steps | Not controlled by this policy | Track separately as runtime supply-chain dependencies |



## Current Allowed GitHub Action Usage



- actions/checkout@v4

- actions/setup-node@v4



## Required Approval Before Adding a New Third-Party Action



A proposed new third-party action must document:



1. Action name and source repository.

2. Business reason.

3. Whether the action needs secrets.

4. Whether the action needs write permissions.

5. Whether the action is pinned to a full-length commit SHA.

6. Owner responsible for future updates.

7. Rollback plan if the action is compromised or deprecated.



## Gaming Studio Risk Context



Third-party actions must be treated as production software dependencies because future workflows may touch:



- game build artifacts

- backend deployment credentials

- signing keys

- package tokens

- telemetry services

- anti-cheat-sensitive configuration

- release manifests

- player-service infrastructure



## Decision



For Lab 14, the repository will allow GitHub-owned actions and block blanket use of third-party Marketplace actions.

