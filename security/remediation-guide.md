
# Developer Remediation Guide



## Purpose



This guide explains how developers should respond to security findings produced by the studio DevSecOps pipeline.



A scanner finding is not the end of the process. A finding must become one of these outcomes:



1. Fixed with evidence.

2. Confirmed as not exploitable with evidence.

3. Accepted temporarily with owner, expiry date, and compensating control.

4. Escalated because it affects production, player data, signing keys, build artifacts, or deployment identity.



## Golden Rule



Do not close a security finding only because the scanner becomes quiet.



Close it only when the underlying risk is fixed, proven non-exploitable, or formally accepted.




---



## SAST Findings



SAST means Static Application Security Testing. It scans source code before the application runs.



### Developer Response Steps



1. Read the finding title.

2. Identify the vulnerable source, sink, and data path.

3. Confirm whether user-controlled input reaches a dangerous operation.

4. Fix the root cause using validation, authorization, safe APIs, encoding, or safer design.

5. Add or update a test that proves the weakness cannot return.

6. Re-run the scanner.

7. Attach the fixed commit, test result, and scanner result to the pull request or issue.



### Common Game-Studio Examples



| Finding Type | Example Risk | Professional Fix |

|---|---|---|

| Unsafe debug endpoint | Hidden admin route exposed in matchmaking API | Remove endpoint or protect it with server-side authorization |

| Client-authoritative economy logic | Client decides whether items or currency can be granted | Move authority to server-side validation |

| Command injection | Build or patch tooling executes unsafe shell input | Use safe argument arrays and strict allowlists |

| Insecure deserialization | Game service trusts serialized player payloads | Use signed payloads and schema validation |



### Minimum Evidence Required



- Link to the fixed commit.

- Short explanation of the root cause.

- Test result showing the issue is blocked.

- Scanner result showing the alert is resolved or intentionally accepted.




---



## Secrets Findings



Secrets findings involve exposed credentials, tokens, keys, certificates, signing material, or deployment credentials.



### Developer Response Steps



1. Stop using the exposed credential immediately.

2. Revoke or disable the credential at its source.

3. Create a replacement credential with the minimum required permissions.

4. Store the replacement in the approved secret store.

5. Remove the secret from code, configuration, logs, and documentation.

6. Search Git history and workflow artifacts.

7. Record the rotation evidence.



### Critical Rule



Never treat deleting the secret from the latest commit as the full fix.



If a real secret was committed, assume it was exposed and rotate it.



### Common Game-Studio Examples



| Secret Type | Example Risk | Professional Fix |

|---|---|---|

| Store upload token | Unauthorized publishing or patch upload | Revoke token and issue scoped replacement |

| Game API signing key | Forged service requests or economy abuse | Rotate key and invalidate old signatures |

| Cloud deploy credential | Unauthorized infrastructure change | Replace static key with OIDC-based short-lived identity |

| Anti-cheat integration token | Sensitive vendor integration abuse | Revoke through vendor portal and update protected environment secret |



### Minimum Evidence Required



- Revocation confirmation.

- Replacement storage location, without revealing the value.

- Owner of the new secret.

- Rotation date.

- Next review date.




---



## Dependency Findings



Dependency findings come from vulnerable open-source packages, lockfiles, containers, or software bill of materials scans.



### Developer Response Steps



1. Identify the affected package and version.

2. Check whether the vulnerable package is used at runtime, build time, or only in development.

3. Prefer a safe upgrade that keeps tests passing.

4. If no safe upgrade exists, check whether the vulnerable function is reachable.

5. Add a temporary compensating control only if the risk is not immediately fixable.

6. Document the decision with owner and expiry date.

7. Re-run dependency scanning.



### Common Game-Studio Examples



| Dependency Area | Example Risk | Professional Fix |

|---|---|---|

| npm backend package | Vulnerable API framework or middleware | Upgrade package and run API tests |

| Container OS package | Vulnerable system library in image | Patch base image or use newer base image |

| Build tool dependency | Compromised or vulnerable build helper | Pin trusted version and replace if abandoned |

| Game telemetry library | Data exposure through vulnerable client SDK | Upgrade SDK and verify telemetry behavior |



### Minimum Evidence Required



- Package name and affected version.

- Fixed version or mitigation.

- Test result.

- Scanner result.

- Risk acceptance issue if not fixed immediately.




---



## Container Findings



Container findings involve vulnerable image layers, unsafe Dockerfile patterns, excessive privileges, or mutable deployment references.



### Developer Response Steps



1. Identify whether the issue is in the base image, application dependency, Dockerfile, or runtime configuration.

2. Update the base image or package where possible.

3. Remove unnecessary packages.

4. Run the service as a non-root user.

5. Avoid deploying by mutable tags such as latest.

6. Deploy by immutable image digest.

7. Rebuild, rescan, and regenerate the container SBOM.



### Common Game-Studio Examples



| Container Issue | Example Risk | Professional Fix |

|---|---|---|

| Root user | Compromised game API has excessive container permissions | Use non-root runtime user |

| Large base image | More unnecessary packages and vulnerabilities | Use slim or distroless-style runtime where practical |

| Mutable tag | Production deploys different image than reviewed | Deploy by digest |

| Missing healthcheck | Broken live service stays in rotation | Add service healthcheck |



### Minimum Evidence Required



- Image name and digest.

- Updated Dockerfile or manifest.

- Container scan result.

- SBOM update.

- Proof that the service still starts successfully.




---



## Infrastructure as Code Findings



IaC findings involve unsafe infrastructure definitions before cloud or Kubernetes resources are deployed.



### Developer Response Steps



1. Identify the affected resource.

2. Determine whether the problem is exposure, encryption, identity, logging, retention, or network access.

3. Fix the infrastructure definition before deployment.

4. Re-run IaC scanning.

5. Confirm the fix does not break expected service behavior.

6. Record the evidence in the pull request.



### Common Game-Studio Examples



| IaC Issue | Example Risk | Professional Fix |

|---|---|---|

| Public storage bucket | Player telemetry or build artifacts exposed | Block public access and require private access paths |

| Overbroad IAM role | CI job can modify unrelated resources | Scope role to exact deployment action |

| Missing logging | Incident investigation becomes impossible | Enable audit and access logging |

| Open admin port | Internal tool exposed to the internet | Restrict by network policy or VPN-only access |



### Minimum Evidence Required



- Resource name.

- Policy or scan rule that failed.

- Fixed configuration.

- Scan result after fix.

- Deployment approval if production is affected.




---



## Risk Acceptance Rules



Risk acceptance is not a way to ignore findings. It is a controlled exception.



A finding may be temporarily accepted only when all of these are true:



1. The finding has a named owner.

2. The business reason is documented.

3. The compensating control is documented.

4. The expiry date is documented.

5. The security reviewer approves it.

6. The finding is reviewed before expiry.



### Never Accept Without Escalation



Escalate immediately if the finding involves:



- Production deployment credentials.

- Player personal data.

- Payment-adjacent systems.

- Signing keys.

- Anti-cheat-sensitive secrets.

- Public exploitability.

- Critical severity in a production-exposed service.



### Required Risk Acceptance Fields



| Field | Required Value |

|---|---|

| Finding ID | Scanner alert or issue link |

| Owner | Named person or team |

| Business Reason | Why it cannot be fixed now |

| Compensating Control | What reduces risk temporarily |

| Expiry Date | Date when exception must be reviewed |

| Reviewer | Security or platform approver |




---



## Developer Quick Decision Tree



Use this decision tree when a scanner finding appears:



1. Is it a real secret?

- Yes: revoke and rotate immediately.

- No: document why it is a safe test fixture or false positive.



2. Is it production-exposed?

- Yes: treat as urgent and escalate.

- No: continue normal remediation.



3. Is there a safe upgrade or direct fix?

- Yes: fix, test, and rescan.

- No: document exploitability and compensating controls.



4. Is the finding a false positive?

- Yes: explain why, link evidence, and request review.

- No: fix or risk-accept with expiry.



5. Does the finding affect player data, economy integrity, signing, deployment identity, or live-ops operations?

- Yes: escalate to security and platform owners.

- No: follow standard remediation flow.

