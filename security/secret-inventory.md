
# Secret Inventory Without Secret Values



## Purpose



This inventory documents secret metadata only.



It must never contain:

- Secret values

- Passwords

- Private keys

- Full access tokens

- Full cloud account credentials

- Recovery codes

- Personal credentials

- Raw signing material



The goal is to know which secrets exist, who owns them, where they are stored, how often they rotate, and what safer replacement pattern should eventually be used.



## Inventory Rules



1. Store names and governance metadata only.

2. Never paste the actual value of a secret.

3. Never paste a private key block.

4. Never paste a full token.

5. Never paste a password.

6. Use team roles instead of individual personal names where possible.

7. Assign every secret an owner.

8. Assign every long-lived secret a rotation cadence.

9. Prefer OIDC, KMS, Vault, or cloud-native secret stores over long-lived GitHub secrets where practical.

10. Treat any accidentally committed value as compromised.



## Secret Metadata Table



| Secret Name | Storage Scope | Owner | Rotation Cadence | Replacement Pattern | Used By | Evidence | Notes |

|---|---|---|---|---|---|---|---|

| GAME_API_SIGNING_KEY | GitHub environment: production | Backend Lead | 90 days | KMS or Vault-backed signing | deploy-placeholder | GitHub environment secret name only | Used to sign API-issued game service tokens. Do not store raw signing material in Git. |

| STORE_UPLOAD_TOKEN | GitHub environment: production | Release Lead | 90 days | OIDC or store-native short-lived publishing token where supported | release workflow future state | GitHub environment secret name only | Used for platform upload automation. Keep separate from developer personal accounts. |

| CLOUD_DEPLOY_ROLE | Cloud IAM | Platform Lead | Temporary | GitHub OIDC federation | deploy-placeholder | OIDC design document | This should be a role trust relationship, not a static cloud key. |

| ANTI_CHEAT_VENDOR_TOKEN | GitHub environment: production | Security Lead | 60 days | Vendor-scoped short-lived token where supported | future anti-cheat integration workflow | Vendor portal record only | High sensitivity because compromise could impact competitive integrity. |

| TELEMETRY_INGEST_TOKEN | GitHub environment: production | Data Platform Lead | 90 days | Managed ingestion identity or workload identity | future telemetry deployment workflow | GitHub environment secret name only | Must align with data minimization and telemetry governance. |

| PAYMENT_WEBHOOK_SECRET | External payment provider dashboard | Backend Lead | 90 days | Provider-managed webhook secret with rotation window | future payment-adjacent service | Provider dashboard record only | Do not expose in pull request logs or test fixtures. |



## Review Checklist



Before merging any change to this file, reviewers must confirm:



- [ ] No actual secret values are present.

- [ ] No private key blocks are present.

- [ ] No personal passwords are present.

- [ ] Every secret has an owner.

- [ ] Every long-lived secret has a rotation cadence.

- [ ] Every secret has a safer replacement pattern.

- [ ] Production secrets are scoped to the production environment where possible.

- [ ] Cloud access prefers OIDC or temporary identity instead of static keys.



## Emergency Handling



If a real value is accidentally added:



1. Stop and do not merge.

2. Revoke or rotate the exposed credential at the source.

3. Remove the value from the branch.

4. Check whether the value was pushed to GitHub.

5. If pushed, treat the secret as compromised.

6. Record the incident in the security tracker.

7. Re-run the secret scanning workflow.

