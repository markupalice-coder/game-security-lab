
# IaC Exception Standard



## Purpose



Infrastructure-as-Code exceptions must be visible, temporary, owned, and reviewable.



An exception is allowed only when fixing the policy finding immediately would create unacceptable delivery risk, operational risk, or business disruption.



## Required Fields



Every IaC exception must include:



| Field | Requirement |

|---|---|

| Policy | The Checkov, Conftest, OPA, Trivy, or manual policy being bypassed |

| Resource | The exact file, module, manifest, or resource affected |

| Environment | Development, staging, production, or shared platform |

| Severity | Low, medium, high, or critical |

| Reason | Why the exception is needed now |

| Compensating Control | What reduces risk while the exception exists |

| Owner | Person or team accountable for remediation |

| Approver | Person allowed to accept the risk |

| Expiry Date | Date when the exception must be reviewed or removed |

| Evidence Link | Scanner output, pull request, control-register entry, or architecture note |



## Rules



1. Exceptions must not be hidden only in code comments.

2. Exceptions must have an expiry date.

3. Critical production exceptions require security approval.

4. Expired exceptions must be reopened, remediated, or re-approved.

5. Permanent exceptions must become policy changes, not repeated temporary waivers.



## Recommended Expiry Windows



| Severity | Maximum Exception Window |

|---|---|

| Critical | 7 days |

| High | 14 days |

| Medium | 30 days |

| Low | 90 days |



## Closure Checklist



Before closing an exception issue, confirm:



- The finding has been remediated, or the risk has been re-approved.

- The control register is updated if the exception affects governance evidence.

- The pull request or scanner evidence is linked.

- The owner and approver are clearly recorded.

