
# Lab 73 Security Context Evidence



## Workload

Kubernetes Deployment: game-api



## Hardened Controls Added

- Pod requires non-root execution.

- Pod uses explicit non-root UID and GID.

- Pod uses RuntimeDefault seccomp profile.

- Container blocks privilege escalation.

- Container root filesystem is read-only.

- Container drops all Linux capabilities.

- Container receives a controlled writable /tmp volume.



## Verification Commands

- kubectl apply --dry-run=client -f deploy/k8s/api.yaml

- docker run --rm -v "$PWD:/repo" aquasec/trivy:latest config /repo/deploy/k8s



## Expected Result

The manifest validates successfully and Trivy shows fewer Kubernetes hardening findings than before Lab 73.

