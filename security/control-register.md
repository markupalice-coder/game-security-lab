


## Lab 11 Permission Governance Note



The CI workflow grants the GitHub Actions token only `contents: read`.

The `api-test` job does not need write access, package publishing access, deployment access, OIDC access, or SARIF upload access.

Future jobs must declare additional permissions only when the job's function requires them.

| Workflow Threat Model | Markdown, STRIDE-style review | Pull request | security/workflow-threat-model.md |


## IaC Exception Standard



- IaC exceptions must be opened through the GitHub issue form: `.github/ISSUE_TEMPLATE/iac-exception.yml`.

- Every exception must include policy, resource, reason, compensating control, expiry date, owner, and approver.

- Approved exceptions must use the labels `iac-exception`, `risk-accepted`, and `security-triage`.

- Expired exceptions must be fixed, reopened, or formally re-approved.

