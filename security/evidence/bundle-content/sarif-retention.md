
# SARIF Retention Strategy



## Purpose



SARIF files are retained so the studio can prove what security scanners reported at a specific point in time.



GitHub Code Scanning is used for developer triage.



Raw SARIF artifacts are retained for audit evidence, release review, incident response, and historical comparison.



## Retention Destinations



| Destination | Purpose | Audience | Retention |

|---|---|---|---|

| GitHub Code Scanning | Developer triage and alert workflow | Developers and security reviewers | Managed by GitHub code scanning behavior |

| GitHub Actions Artifact | Raw scanner evidence | Security, platform, release, and audit reviewers | 90 days for this lab |

| Release Evidence Bundle | Release support window evidence | Security, compliance, and incident response | At least one support window |



## Retention Rules



1. Pull request SARIF is used for fast developer feedback.

2. Main branch SARIF is retained as baseline evidence.

3. Release SARIF must be included in the release evidence bundle.

4. Raw SARIF artifacts must use explicit retention settings.

5. SARIF must not contain secrets, tokens, private keys, passwords, or player data.

6. If a SARIF file contains sensitive data, delete the artifact, rotate affected credentials, and rerun the scan after redaction.

7. If the required support window is longer than the GitHub artifact limit, export the release evidence bundle to a controlled long-term archive.



## Minimum Required Metadata



Every retained SARIF artifact should be traceable to:



- Repository

- Commit SHA

- Branch or tag

- Workflow name

- Workflow run ID

- Scanner name

- Scan timestamp

- Release version if applicable



## Ownership



Security owns the retention policy.



Platform engineering owns the workflow implementation.



Development teams own remediation of findings.



Release engineering owns release evidence completeness.



## Review Cycle



This retention strategy must be reviewed every 90 days or whenever the studio changes scanner tooling, repository visibility, release support windows, or compliance requirements.




## Production Workflow Pattern



Add this pattern after any scanner generates a SARIF file:



```yaml

- name: Validate SARIF before retention

run: python3 scripts/validate-sarif-for-retention.py path/to/results.sarif



- name: Upload SARIF to GitHub Code Scanning

uses: github/codeql-action/upload-sarif@v4

with:

sarif_file: path/to/results.sarif



- name: Retain raw SARIF as release evidence

if: always()

uses: actions/upload-artifact@v4

with:

name: scanner-sarif-${{ github.sha }}

path: path/to/results.sarif

retention-days: 90



This keeps developer triage and audit evidence connected but separate.
