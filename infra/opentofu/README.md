# OpenTofu Infrastructure Skeleton

This folder is the starting point for Infrastructure as Code in the gaming DevSecOps lab series.

## Purpose

The skeleton defines:

- OpenTofu version compatibility
- Environment selection
- Shared project metadata
- Standard tags for future infrastructure resources
- Safe validation before cloud resources are introduced

## Current Scope

This lab does not create real cloud resources.

Future labs will add:

- IaC scanning
- Policy-as-code
- Cloud providers
- Remote state
- Kubernetes deployment targets
- GitOps integration

## Safe Local Commands

Run these commands from the infra/opentofu directory:

```bash
tofu fmt -recursive
tofu init -backend=false
tofu validate
```
