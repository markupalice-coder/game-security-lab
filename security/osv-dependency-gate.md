
# OSV Dependency Gate



## Purpose

This control scans the API npm lockfile for known vulnerable dependency versions.



## Scope

- Target: src/api/package-lock.json

- Trigger: pull requests and pushes to main

- Tool: OSV-Scanner via GitHub Actions

- Evidence: GitHub Actions run logs and security scan output



## Operating Rule

If OSV reports a vulnerable dependency, the team must either:

1. Upgrade the dependency,

2. Remove the dependency,

3. Replace the dependency, or

4. Create a time-bound risk acceptance issue with owner, reason, compensating control, and expiry date.



## Gaming Studio Context

This protects backend game services from shipping vulnerable npm packages into matchmaking, telemetry, player-profile, economy, or live-ops APIs.

