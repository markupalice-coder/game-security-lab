
# Secret Rotation Drill



## Scenario



A fake game API signing key was detected in a pull request. The value is confirmed to be a training fixture, but the team will practice the full rotation process.



## Drill Rules



1. Do not create or paste real secrets.

2. Do not disable Gitleaks.

3. Do not remove the Lab 34 allowlist unless instructed.

4. Do not rewrite Git history for the fake training value.

5. Practice the communication and verification steps as if this were real.



## Drill Steps



| Step | Action | Owner | Result |

|---|---|---|---|

| 1 | Confirm the detected value is fake | Security Reviewer | |

| 2 | Identify the hypothetical owner | Incident Commander | |

| 3 | Read the rotation runbook | Secret Owner | |

| 4 | Confirm where the secret would be stored | Platform Owner | |

| 5 | Run Gitleaks verification | Security Reviewer | |

| 6 | Record lessons learned | Release Owner | |



## Drill Completion Evidence



Paste the output of this command into the drill notes:



```bash

./scripts/secret-rotation-audit.sh



Lessons Learned
What slowed the response?

Was the owner obvious?

Was the storage location obvious?

Did the runbook explain the next action clearly?

What prevention improvement should be added?
