
# Signed Commit Awareness Policy



## Purpose

Signed commits help the studio verify that important repository changes came from a trusted developer or automation identity.



## Current Lab Scope

This lab introduces awareness and safe enforcement testing. It does not yet implement artifact signing, release signing, SLSA provenance, or production deployment identity.



## Required Team Understanding

- A commit author name is not proof of identity.

- A commit email is not proof of identity.

- A verified cryptographic signature is stronger evidence of identity.

- Unsigned commits may be acceptable during onboarding, but protected branches should move toward verified signatures.



## Rollout Strategy

1. Audit current commit signature status.

2. Teach developers how to configure signing.

3. Test signed commits on a feature branch.

4. Enable signed-commit requirement on main.

5. Add exceptions only for approved bots or documented migration cases.



## Bot and Automation Rule

Automation accounts must either produce verified commits or be documented as temporary exceptions with an owner and expiry date.

