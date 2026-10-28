
# GitHub OIDC Design



## Purpose



Replace long-lived cloud access keys in GitHub Actions with short-lived cloud credentials issued only after the cloud provider validates GitHub Actions identity claims.



## Old Pattern: Static Cloud Keys



A GitHub Actions workflow stores a cloud access key and secret key as repository or environment secrets. The workflow reads those secrets at runtime.



Risk:

- The key may live for months.

- A compromised workflow can exfiltrate it.

- Rotation depends on humans remembering the runbook.

- The key may be overprivileged.

- Forked or misconfigured workflows increase exposure risk.



## New Pattern: OIDC Federation



1. A GitHub Actions job asks GitHub for an OIDC identity token.

2. GitHub creates a short-lived signed token for that specific job.

3. The cloud provider validates token claims such as repository, branch, workflow, and environment.

4. The cloud provider exchanges the validated token for temporary credentials.

5. The workflow uses temporary credentials only for the current job.

6. No static cloud access key is stored in GitHub secrets.



## Gaming Studio Context



This pattern protects sensitive build and deployment paths such as:

- Game server deployment.

- Matchmaking API release.

- Telemetry pipeline deployment.

- Patch artifact publishing.

- Container image promotion.

- Store upload automation.

- Anti-cheat-adjacent service deployment.



## Minimum Trust Restrictions



The cloud role must restrict:

- Repository owner.

- Repository name.

- Branch or tag.

- Workflow purpose.

- Deployment environment when production protection is introduced.

- Least-privilege cloud permissions.



## Lab 36 Boundary



This lab creates the OIDC design and safe templates. It does not deploy production infrastructure. Lab 37 will add production environment protection before any real deployment path is connected.



## Non-Negotiable Rule



Do not store static cloud access keys in repository secrets for deployment workflows once OIDC is available.

