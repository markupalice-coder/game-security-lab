# Sovereign Deployment Matrix

## Purpose

This document maps each game-service deployment region to the player data, telemetry, logs, secrets, approvals, and evidence that must remain region-aware.

## Regional Boundaries

| Region | Player Data | Telemetry | Incident Evidence | Secrets | Logs | Deployment Approval |
|---|---|---|---|---|---|---|
| eu | EU player data remains in EU-approved systems | EU telemetry remains in EU-approved systems | EU evidence retained regionally | production-eu | regional | Privacy Owner + Release Manager |
| us | US player data remains in US-approved systems | US telemetry remains in US-approved systems | US evidence retained regionally | production-us | regional | Release Manager |
| apac | APAC player data stays close to APAC services where required | APAC telemetry follows local retention rules | APAC evidence retained regionally | production-apac | regional | Regional Operations + Release Manager |

## Controls

1. Use regional GitHub Environments.
2. Use regional secrets and variables.
3. Keep logs regional unless transfer is documented.
4. Keep SBOM and release evidence tied to the region.
5. Require region-specific approval before deployment.
6. Do not use global deployment credentials.
7. Do not centralize raw telemetry by default.
8. Document any cross-region transfer before implementation.

## Lab 93 Scope

This lab creates the matrix and validates the policy. It does not deploy to a real cloud provider.

**Behind the Scenes:**
This document turns privacy and sovereignty requirements into a reviewable architecture artifact. It gives humans a clear map of what belongs in each region.
