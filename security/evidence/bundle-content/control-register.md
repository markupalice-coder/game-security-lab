
## Lab 11 Permission Governance Note

The CI workflow grants the GitHub Actions token only `contents: read`.

The `api-test` job does not need write access, package publishing access, deployment access, OIDC access, or SARIF upload access.

Future jobs must declare additional permissions only when the job's function requires them.

| Workflow Threat Model | Markdown, STRIDE-style review | Pull request | security/workflow-threat-model.md |

## IaC Mapping

| Control ID | Control Name | Scanner Signal | Applies To | Gate | Owner | Evidence | Required Response |
|---|---|---|---|---|---|---|---|
| IAC-001 | IaC Misconfiguration Baseline | Checkov failed checks | infra/ and deployment configuration | Pull request and evidence workflow | Platform Team | security/out/checkov-iac.json and security/out/iac-control-evidence.md | Remediate unsafe configuration or document a future exception |
| IAC-002 | Studio-Specific Policy Enforcement | Conftest and OPA/Rego deny results | policies/rego and policy fixtures | Pull request and evidence workflow | Security Team | security/out/conftest-iac.json and security/out/iac-control-evidence.md | Fix the policy violation or assign an accountable owner |
| IAC-003 | Finding Accountability | Control evidence report | All IaC findings | Review process | Security and Platform Leads | security/out/iac-control-evidence.md | Every finding must have severity, owner, remediation, and exception expiry when accepted |

## IaC Exception Standard

- IaC exceptions must be opened through the GitHub issue form: `.github/ISSUE_TEMPLATE/iac-exception.yml`.

- Every exception must include policy, resource, reason, compensating control, expiry date, owner, and approver.

- Approved exceptions must use the labels `iac-exception`, `risk-accepted`, and `security-triage`.

- Expired exceptions must be fixed, reopened, or formally re-approved.
