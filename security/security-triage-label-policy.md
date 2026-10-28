
# Security Finding Triage Label Policy



## Purpose



Security scanner findings must become accountable work items. Labels help the studio separate urgent release blockers from review items and time-bound exceptions.



## Labels



| Label | Meaning | Required Action |

|---|---|---|

| security-critical | Blocks release until fixed | Assign owner immediately, fix before release, and verify scanner pass |

| security-triage | Needs security review | Security reviewer decides severity, exploitability, and next step |

| risk-accepted | Accepted with owner and expiry | Must include owner, business reason, compensating control, and expiry date |



## Rules



1. Do not use risk-accepted for convenience.

2. Every risk-accepted issue must have an expiry date.

3. Every security-critical issue must be linked to a fix pull request.

4. Every security-triage issue must be reviewed before release planning.

5. False positives must be documented, not silently ignored.



## Gaming Studio Examples



- Client-side economy authority finding: security-triage

- Exposed admin/debug endpoint in matchmaking API: security-critical

- Temporary dependency exception with no active exploit path: risk-accepted

