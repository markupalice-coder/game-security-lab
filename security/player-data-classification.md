
# Player Data Classification



## Purpose



This document defines how the studio classifies player-related data before it is collected, logged, stored, shared, analyzed, or used in security workflows.



The goal is simple: every developer should know whether a data item belongs in a public lobby, an internal workroom, a confidential office, or a restricted vault.



## Classification Levels



| Class | Plain-English Meaning | Gaming Examples | Minimum Handling Rule |

|---|---|---|---|

| Public | Safe for approved public display | Approved leaderboard display names, public patch notes, public tournament aliases | Review before publishing |

| Internal | Useful to the studio but not intended for players | Aggregated telemetry, build metrics, service health, anonymized crash counts | Keep inside approved studio systems |

| Confidential | Could harm players, staff, or the studio if exposed | Account identifiers, support tickets, moderation records, fraud-review notes, raw crash reports with identifiers | Restrict access, encrypt, log access, define retention |

| Restricted | Highest-risk data requiring vault-level control | Payment-adjacent tokens, anti-cheat secrets, signing keys, production deployment credentials, raw authentication secrets | Avoid storing when possible; isolate, encrypt, approve, rotate, and monitor |



## Default Rule



When classification is unclear, choose the stricter class until the security owner approves a lower classification.



## Required Controls



| Control | Public | Internal | Confidential | Restricted |

|---|---|---|---|---|

| Collection minimization | Required | Required | Required | Mandatory |

| Access control | Basic | Team-limited | Need-to-know | Explicit approval only |

| Encryption in transit | Required | Required | Required | Required |

| Encryption at rest | Recommended | Required | Required | Required |

| Retention limit | Recommended | Required | Required | Mandatory |

| Access logging | Optional | Recommended | Required | Required |

| Security review before change | Recommended | Recommended | Required | Required |

| Production use approval | Not usually needed | Team approval | Security owner approval | Security and platform owner approval |



## Gaming Studio Examples



### Public



- Approved display names shown on leaderboards.

- Public tournament aliases.

- Public patch notes.

- Public server status messages.



### Internal



- Aggregated match duration metrics.

- Aggregated crash counts.

- Build pipeline timing.

- Service health metrics.

- Non-identifying regional latency statistics.



### Confidential



- Player account identifiers.

- Support tickets.

- Moderation reports.

- Fraud investigation notes.

- Raw crash reports containing device or account identifiers.

- Player email addresses.



### Restricted



- Payment-adjacent tokens.

- Anti-cheat secrets.

- Game signing keys.

- Store upload credentials.

- Production cloud deployment role mappings.

- Raw authentication tokens.

- Private keys.



## Engineering Rules



1. Do not collect data without a clear purpose.

2. Do not log confidential or restricted data unless explicitly approved.

3. Do not store restricted data in Git, CI logs, artifacts, dashboards, or chat tools.

4. Do not put player identifiers into build artifacts unless required and approved.

5. Always define retention for internal, confidential, and restricted data.

6. Prefer aggregated or pseudonymized telemetry over raw player-level records.

7. Treat unknown data as confidential until reviewed.

8. Treat credentials, keys, and anti-cheat material as restricted even if they do not directly identify a player.



## Review Owners



| Area | Primary Owner |

|---|---|

| Public publishing | Community or release owner |

| Internal telemetry | Analytics owner |

| Confidential player records | Security owner |

| Restricted secrets and signing material | Security owner and platform owner |



## Evidence Produced by This Lab



- Human-readable policy: `security/player-data-classification.md`

- Machine-readable catalog: `security/player-data-classification.json`

- Validator script: `scripts/validate-player-data-classification.py`

- CI workflow gate: `.github/workflows/player-data-classification.yml`

