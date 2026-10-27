
# GitHub Actions Threat Model



## Purpose



This document identifies the most important assets, entry points, threats, and controls for the game-security-lab GitHub Actions pipeline.



The goal is not to predict every possible attack. The goal is to make the highest-risk workflow paths visible, reviewable, and enforceable before more security scanners and release automation are added.



## Scope



Included:



- GitHub Actions workflow files in `.github/workflows`

- Pull request and push-triggered automation

- Repository source code used by workflow jobs

- Build outputs, SBOMs, logs, and artifacts

- Default `GITHUB_TOKEN` permissions

- Third-party and reusable actions

- Package installation steps

- Future deployment credentials and OIDC design



Excluded for now:



- Kubernetes runtime security

- Cloud infrastructure policy

- Container image signing enforcement

- Production deployment approval gates



Those topics will be handled in later labs.



## System Overview



```mermaid

flowchart LR

Developer[Developer] --> PR[Pull Request]

PR --> Workflow[GitHub Actions Workflow]

Workflow --> Checkout[Checkout Source Code]

Workflow --> Packages[Install Packages]

Workflow --> Tests[Run Tests and Linters]

Workflow --> Artifacts[Create Logs and Artifacts]

Workflow --> GitHubToken[GITHUB_TOKEN]

Workflow --> FutureDeploy[Future Deployment Path]



Assets
Asset

Why It Matters

Example Failure

GITHUB_TOKEN

Can read repository data and may gain write permissions if misconfigured

Attacker modifies code, releases, or pull request metadata

Source code

Contains game service logic, API behavior, and security assumptions

Malicious change enters protected branch

Workflow files

Define trusted automation behavior

Unsafe workflow executes attacker-controlled commands

Build artifacts

May become release candidates or evidence

Artifact tampering changes what gets shipped

SBOMs and reports

Support audit and vulnerability response

Missing or altered evidence breaks investigation

Package install process

Pulls code from external ecosystems

Dependency compromise affects build job

Future deployment credentials

Will later access cloud or production resources

Credential theft enables unauthorized deployment

Game signing or patch artifacts

Protect player trust and update integrity

Tampered patch or signed build reaches players

Entry Points
Entry Point

Trust Level

Risk

Pull requests

Untrusted until reviewed

Malicious code may influence workflow behavior

Pushes to main

Trusted but still sensitive

Compromised maintainer account could push unsafe changes

Third-party actions

Partially trusted after allowlisting

Approved action could be compromised later

Workflow commands

Sensitive

Unsafe input can alter logs, outputs, or execution

Package installs

External dependency trust

Malicious package or post-install script could execute

Artifacts and caches

Shared build data

Poisoned cache or artifact may affect later jobs

Repository secrets

Highly sensitive

Secret exposure can compromise external systems

Manual workflow dispatch

Trusted user action

Wrong inputs could trigger unsafe release behavior later

Threats and Controls
ID

Threat

Asset at Risk

Likely Entry Point

Impact

Control

T1

Overprivileged workflow token

GITHUB_TOKEN

Any workflow job

Repository modification or release abuse

Set default permissions to contents: read; elevate only per job

T2

Untrusted pull request code execution

Secrets and runner context

Pull requests

Secret exposure or malicious execution

Avoid unsafe pull_request_target; do not expose secrets to fork PRs

T3

Third-party action compromise

Workflow integrity

uses: steps

Supply-chain execution inside CI

Restrict allowed actions and pin approved actions

T4

Command injection through workflow context

Runner shell

Pull request metadata or event fields

Attacker-controlled shell execution

Move untrusted context into environment variables and quote safely

T5

Artifact tampering

Build outputs and evidence

Upload/download artifact steps

Unsafe or misleading release evidence

Use immutable naming, checksums, future signing, and retention rules

T6

Dependency chain abuse

Build job

Package installation

Malicious dependency executes during build

Use lockfiles, dependency review, OSV, and later SBOM scanning

T7

Secret exposure in logs

Secrets and tokens

Debug output or failed scripts

Credential compromise

Avoid printing secrets; rotate exposed values immediately

T8

Missing evidence

Audit trail

Workflow failure or skipped jobs

Security cannot prove what happened

Store SARIF, SBOMs, logs, and release manifests in later labs

T9

Game patch or build integrity failure

Player trust and live-ops release

Build artifact path

Tampered update reaches players

Later use signing, provenance, digest discipline, and deployment gates

T10

Reviewer bypass for workflow changes

Workflow files

Pull request review process

Malicious workflow enters main branch

CODEOWNERS and branch protection for .github/workflows/

Current Controls Already Implemented
CI workflow exists.

Branch protection exists.

Required checks exist.

CODEOWNERS exists for sensitive paths.

Least-privilege workflow permissions have started.

actionlint exists locally and in CI.

Third-party action policy has been reviewed.

Control Gaps for Future Labs
Gap

Planned Lab Direction

Inline risky shell remains in workflows

Replace inline risky shell with reviewed script files

Workflow context injection checks are not automated yet

Add SAST rules for workflow YAML

Secret detection is not active yet

Add Gitleaks locally and in CI

Dependency scanning is not active yet

Add OSV, npm audit, Dependabot, and SBOMs

Container artifact trust is not implemented yet

Add Trivy, Syft, Grype, cosign design, and digest discipline

Deployment identity is not implemented yet

Replace long-lived credentials with OIDC design

Security Review Checklist
Before approving workflow changes, reviewers must ask:

Does this workflow need the permissions it requests?

Does this workflow run on untrusted pull request input?

Does it use any third-party action not approved by policy?

Is any action referenced by a mutable tag instead of a reviewed version?

Could pull request title, body, branch name, commit message, or file content reach a shell command?

Could this job print secrets, tokens, or credentials?

Does this job create artifacts that could later be trusted by another job?

Is there enough evidence to investigate a failed or suspicious run?

Owner
Primary owner: Security reviewer or repository maintainer.

Backup owner: Platform engineering reviewer.

Review Cadence
Review this threat model whenever:

A new workflow is added.

A workflow receives broader permissions.

A new third-party action is introduced.

A deployment path is introduced.

Secrets, artifacts, SBOMs, signing, or OIDC are added.
