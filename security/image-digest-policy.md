
# Image Digest Discipline Policy



## Purpose



Game service containers must be tracked by immutable digest, not only by mutable tag.



## Rules



1. Tags such as latest, lab56, staging, and production are human-friendly pointers only.

2. Release candidates must record a pinned image reference in the form image@sha256:digest.

3. Production deployment manifests must use pinned digest references wherever possible.

4. Digest evidence must include image tag, image digest, pinned image reference, UTC capture time, and source commit.

5. If a tag is rebuilt, the digest must be captured again.

6. SBOMs, vulnerability scans, future signatures, and release manifests must refer to the same digest.

7. Mutable tags must not be treated as proof of what was deployed.



## Gaming-Studio Context



A live game backend may serve matchmaking, inventory, telemetry, or economy APIs. If a deployment says only game-api:latest, the studio cannot reliably prove which image version handled player traffic. Digest discipline creates the artifact identity needed for incident response, rollback, signing, SBOM correlation, and audit evidence.

