
# AI-Assisted Workflow Safety



## Purpose



AI tools may help create issues, summarize findings, draft pull requests, generate code, or suggest remediations. They must not become trusted release authorities.



## Mandatory Rules



1. Do not pass untrusted issue, pull request, review, discussion, or comment text directly into an AI agent that has repository write access.

2. Do not let AI agents access production secrets, store-upload credentials, anti-cheat secrets, signing keys, cloud deployment roles, or payment-adjacent credentials.

3. Require human approval before AI-generated code changes merge.

4. Run all existing scanner gates on AI-generated pull requests.

5. Keep prompt, tool-call, and output logs inside approved retention boundaries.

6. Treat AI output as untrusted until reviewed, tested, scanned, and approved.

7. AI agents must not approve their own pull requests.

8. AI agents must not modify GitHub Actions workflows without code-owner review.

9. AI agents must not create releases, publish containers, rotate secrets, or deploy to production.

10. Any exception must have an owner, expiry date, compensating control, and security review.



## Gaming Studio Context



AI-assisted work can touch sensitive studio assets such as game economy logic, live-ops scripts, telemetry schemas, moderation tools, anti-cheat integrations, signing keys, build artifacts, and platform store credentials.



## Required Evidence



- Pull request review record

- Scanner results

- Human approval

- Linked issue or risk acceptance

- Retention decision for AI logs

- Evidence that production secrets were not exposed

