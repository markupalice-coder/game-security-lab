
# Secret Rotation Runbook



## Purpose



This runbook explains how to respond when a secret is exposed in the game-security-lab repository or in a connected GitHub Actions workflow.



A secret may include an API key, cloud token, signing key, package token, store upload credential, webhook secret, database password, anti-cheat integration key, telemetry token, or deployment credential.



## Golden Rule



Treat every leaked secret as compromised.



Do not only delete the secret from the code. First revoke it at the source, then replace it, then verify that the replacement works.



## Severity Levels



| Level | Meaning | Example | Required Response |

|---|---|---|---|

| Critical | Secret can deploy, publish, sign, delete, or access production systems | Cloud deploy role, game signing key, store upload token | Stop affected path, revoke immediately, notify owner |

| High | Secret can access sensitive non-production systems or player-adjacent data | Staging database token, telemetry API key | Revoke quickly, replace, verify logs |

| Medium | Secret is scoped to low-risk development systems | Local dev token, test webhook secret | Rotate, document, improve prevention |

| Low | Confirmed fake or training-only fixture | Fake AWS example key in security/fake-secret-test.txt | Keep allowlisted only if documented |



## Rotation Roles



| Role | Responsibility |

|---|---|

| Incident Commander | Coordinates the rotation and decides when the affected path can resume |

| Secret Owner | Revokes and recreates the credential at the source system |

| Platform Owner | Updates GitHub Actions secrets, environments, or deployment configuration |

| Security Reviewer | Confirms Gitleaks and secret scanning results are clean |

| Release Owner | Reruns impacted workflows and verifies game-service delivery |



## Immediate Response Checklist



1. Stop the affected deployment or release path.

2. Identify the leaked secret type and owner.

3. Revoke the exposed credential at the original provider.

4. Generate a replacement credential with the smallest required permissions.

5. Update GitHub Actions, environment secrets, or the external secret manager.

6. Rerun the impacted workflows.

7. Search repository history, workflow logs, artifacts, and open pull requests.

8. Record the incident, evidence, owner, and expiry follow-up.

9. Add a prevention improvement so the same mistake is harder to repeat.



## GitHub UI Rotation Procedure



Use this when a GitHub Actions secret must be replaced manually.



1. Open the repository in GitHub.

2. Click **Settings**.

3. In the left sidebar, click **Secrets and variables**.

4. Click **Actions**.

5. Select **Repository secrets** or **Environment secrets**, depending on where the secret is stored.

6. Find the affected secret name.

7. Click **Update**.

8. Paste the replacement value into **Secret**.

9. Click **Update secret**.

10. Go to the **Actions** tab.

11. Rerun the affected workflow.

12. Confirm the workflow succeeds without printing the secret value.



## GitHub CLI Rotation Procedure



Use this when you want to update a repository secret from the terminal without placing the secret value directly in shell history.



```bash

read -rsp "Paste replacement GAME_API_SIGNING_KEY: " NEW_GAME_API_SIGNING_KEY

echo

printf '%s' "$NEW_GAME_API_SIGNING_KEY" | gh secret set GAME_API_SIGNING_KEY --body-file -

unset NEW_GAME_API_SIGNING_KEY



This command prompts for the new value, sends it to GitHub as the secret body, and then removes the temporary shell variable.

Gitleaks Verification
Run this after documentation or code changes.

docker run --rm -v "$PWD:/repo" zricethezav/gitleaks:latest detect --source=/repo --config=/repo/.gitleaks.toml --redact



Expected result: no real secret leaks should be reported.

If Gitleaks reports a real credential, stop and rotate the credential before continuing.

Repository History Search
Run this to search common secret-related words in the current working tree.

git grep -n -I -E "SECRET|TOKEN|PASSWORD|PRIVATE_KEY|AWS_ACCESS_KEY|AWS_SECRET_ACCESS_KEY" -- . ':!security/secret-rotation-runbook.md'



Expected result: only safe placeholder names, documentation labels, or known training fixtures should appear.

Workflow and Artifact Review
Open GitHub.

Click Actions.

Open the failed or suspicious workflow run.

Expand each job.

Search the logs for the exposed secret name, not the secret value.

Click Artifacts, if present.

Download only if required for incident review.

Do not share artifacts outside the response team.

Delete or expire unsafe artifacts according to studio policy.

Rotation Record Template
Copy this section into an incident issue or security ticket.

Field

Value

Incident ID



Date Detected



Detected By

Gitleaks / GitHub Secret Scanning / Developer / External Report

Secret Name



Secret Type

API key / Cloud role / Signing key / Store token / Webhook secret

Environment

Dev / Staging / Production

Owner



Was Secret Revoked?

Yes / No

Replacement Created?

Yes / No

GitHub Secret Updated?

Yes / No

Workflows Rerun?

Yes / No

Logs and Artifacts Checked?

Yes / No

Follow-Up Prevention Task



Expiry Review Date



Gaming Studio Examples
Secret

Why It Matters

Rotation Priority

GAME_API_SIGNING_KEY

May sign trusted game-service requests

Critical

STORE_UPLOAD_TOKEN

May publish or modify build artifacts

Critical

TELEMETRY_WRITE_TOKEN

May pollute analytics or leak player telemetry

High

ANTI_CHEAT_VENDOR_KEY

May expose protected integration access

Critical

MATCHMAKING_SERVICE_TOKEN

May affect live multiplayer service behavior

High

DISCORD_WEBHOOK_URL

May allow spam or social-engineering messages

Medium

Done Criteria
The incident is complete only when:

The old credential is revoked.

The replacement credential is active.

GitHub Actions or deployment configuration uses the replacement.

Gitleaks passes.

Relevant workflows pass.

Logs and artifacts were reviewed.

A written incident record exists.

A prevention improvement is assigned.
