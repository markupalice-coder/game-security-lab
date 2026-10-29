
# GitOps Operating Contract



## Approved Source



Only the `main` branch of this repository may represent the approved desired state for the lab environment.



## Deployment Path



Argo CD watches:



- Repository: this GitHub repository

- Branch: `main`

- Path: `deploy/k8s`

- Destination namespace: `game`



## Manual Change Policy



Manual `kubectl apply`, `kubectl edit`, and `kubectl delete` are allowed only for learning, break-glass recovery, or troubleshooting.



Any long-term change must be committed to Git.



## Rollback Policy



Rollback must be performed by reverting Git to a known good commit.



## Secret Policy



No secret values may be stored in Git.



Future labs must use an external secret-management pattern or sealed/encrypted secret workflow.



## Security Gate Policy



Before production sync, the repository must pass:



- CI tests

- SAST

- secret scanning

- dependency scanning

- container scanning

- IaC scanning

- artifact signing checks

