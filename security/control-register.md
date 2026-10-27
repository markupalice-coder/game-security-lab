


## Lab 11 Permission Governance Note



The CI workflow grants the GitHub Actions token only `contents: read`.

The `api-test` job does not need write access, package publishing access, deployment access, OIDC access, or SARIF upload access.

Future jobs must declare additional permissions only when the job's function requires them.

| Workflow Threat Model | Markdown, STRIDE-style review | Pull request | security/workflow-threat-model.md |