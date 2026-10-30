
# AI-Assisted Change Checklist



Use this template when AI helped create code, workflow changes, policy changes, documentation, tests, or remediation.



## AI Use Disclosure



- [ ] I used an AI assistant for this change.

- [ ] I reviewed all AI-generated output before committing.

- [ ] I removed hallucinated, irrelevant, or unverifiable content.



## Security Controls



- [ ] No production secrets were exposed to the AI assistant.

- [ ] No anti-cheat secrets, signing keys, store tokens, or payment-adjacent credentials were exposed.

- [ ] The AI assistant did not approve its own pull request.

- [ ] The AI assistant did not deploy to production.

- [ ] The AI assistant did not publish a release artifact.

- [ ] Workflow changes were reviewed by the correct code owner.



## Required Scanners



- [ ] CodeQL passed.

- [ ] Semgrep passed.

- [ ] Gitleaks passed.

- [ ] OSV or dependency review passed.

- [ ] Container scan passed where applicable.

- [ ] IaC scan passed where applicable.



## Human Review



- [ ] A human reviewer validated the logic.

- [ ] A human reviewer validated the security impact.

- [ ] Any exception has an owner, expiry date, compensating control, and security review.

