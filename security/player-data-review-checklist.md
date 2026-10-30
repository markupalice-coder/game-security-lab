
# Player Data Review Checklist



Use this checklist when a pull request adds telemetry, logging, analytics, support tooling, moderation tooling, anti-cheat logic, authentication changes, payment-adjacent flows, or production secrets.



## Required Questions



1. What player or studio data is being collected, processed, logged, or stored?

2. Is the data classified as Public, Internal, Confidential, or Restricted?

3. Is the purpose of collection documented?

4. Is collection minimized to the smallest useful dataset?

5. Is the retention period defined?

6. Is access limited to the correct owner or team?

7. Is confidential or restricted data encrypted in transit and at rest?

8. Could this data appear in CI logs, artifacts, dashboards, crash dumps, or support exports?

9. Does the change require security owner review?

10. If classification is unclear, has the stricter class been chosen?



## Automatic Escalation Rules



- If the data contains account identifiers, choose Confidential or stricter.

- If the data contains credentials, tokens, signing keys, anti-cheat secrets, or deployment credentials, choose Restricted.

- If the data may appear in player-facing UI, verify that it is approved Public data.

- If the data is telemetry, confirm that raw identifiers are removed or justified.

