
# Full Security Control Review Checklist



## Release Identity

- [ ] Repository is on the intended release branch.

- [ ] Working tree is clean before review.

- [ ] Latest commit is known and recorded.

- [ ] Pull request exists for review.



## Source Governance

- [ ] Branch protection is enabled.

- [ ] Required checks are configured.

- [ ] CODEOWNERS covers security-sensitive paths.

- [ ] Workflow permissions follow least privilege.



## Scanner Coverage

- [ ] API tests run successfully.

- [ ] SAST coverage exists.

- [ ] Secret scanning exists.

- [ ] Dependency scanning exists.

- [ ] SBOM generation exists.

- [ ] SBOM vulnerability scanning exists.

- [ ] Container scanning exists where image builds exist.

- [ ] IaC scanning exists.

- [ ] SARIF retention strategy exists.



## Policy and Triage

- [ ] Severity policy exists.

- [ ] Vulnerability SLA exists.

- [ ] Risk acceptance process exists.

- [ ] Developer remediation guide exists.



## Evidence

- [ ] Evidence bundle is generated.

- [ ] Evidence bundle is uploaded by CI.

- [ ] Evidence does not contain secrets.

- [ ] Generated artifacts have a defined retention period.



## Release Decision

- [ ] Blocking findings are fixed or formally accepted.

- [ ] Warnings are triaged.

- [ ] Rollback plan is known.

- [ ] Reviewer can explain the release decision.

