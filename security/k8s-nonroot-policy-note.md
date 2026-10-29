
# Kubernetes Non-Root Workload Policy



This policy requires game API Deployments to declare non-root execution before they are deployed.



## Why this matters



Running as root gives a compromised container more power than it needs. A game service should run with the smallest practical privilege set so that a vulnerability in the API does not automatically become a larger node or cluster risk.



## What this policy checks



- Deployment pod templates must set `spec.template.spec.securityContext.runAsNonRoot: true`.

- Pod templates must not set `runAsUser: 0`.

- Containers must not set `runAsNonRoot: false`.

- Containers must not set `runAsUser: 0`.



## Current scope



This lab tests policy locally with Conftest. It does not install an admission controller yet. Live cluster testing begins in Lab 76 and production-style admission enforcement comes later.

