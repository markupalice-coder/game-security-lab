
# Cosign Keyless Signing Design



## Purpose



This document defines how the game API container image will be signed without long-lived private signing keys.



## Current Lab Scope



Lab 58 creates the signing design and validates OIDC readiness.



This lab does not require a production registry.

This lab does not require a real production deployment.

This lab does not yet enforce digest-only deployment.



## Previous Evidence



The container SBOM from Lab 57 is stored at:



security/out/game-api.spdx.json



## Target Signing Flow



1. GitHub Actions checks out the repository.

2. GitHub Actions builds the game API image.

3. GitHub Actions pushes the image to an OCI-compatible registry.

4. GitHub Actions requests an OIDC identity token.

5. Cosign uses that OIDC identity for keyless signing.

6. The signature is attached to registry-backed metadata.

7. Deployment systems verify the signature before trusting the image.



## Trusted Identity Pattern



Expected GitHub repository:



markupalice-coder/game-security-lab



Expected future workflow identity pattern:



https://github.com/markupalice-coder/game-security-lab/.github/workflows/cosign-keyless-signing.yml@refs/heads/main



Expected OIDC issuer:



https://token.actions.githubusercontent.com



## Security Rules



- Do not create or store static Cosign private keys for this learning path.

- Do not print OIDC tokens in workflow logs.

- Do not sign images from untrusted pull request code.

- Do not treat a signature as useful unless deployment verification exists.

- Do not deploy by mutable tag alone.

- Require branch protection before production signing.

- Require verification before future Kubernetes or GitOps deployment.



## Gaming-Studio Context



This protects build artifacts that may contain multiplayer server code, telemetry services, matchmaking APIs, economy logic, or live-ops backend components.



A signed artifact gives the studio evidence that a container came from a known workflow path instead of an unknown developer laptop or compromised registry upload.



## Future Enforcement Path



Lab 59 will introduce image digest discipline.



Later labs can enforce:



- signed image verification

- signed provenance

- Kubernetes admission policy

- GitOps deployment approval

- runtime monitoring tied back to image identity

