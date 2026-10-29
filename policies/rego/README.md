
# Rego Policies



This folder contains custom policy-as-code rules for the gaming DevSecOps lab series.



## Current Policy



- `required-tags.rego`: Denies service resources that do not include an `environment` tag.



## Why This Matters



Environment tags help teams identify whether a resource belongs to development, staging, or production. In gaming studios, this prevents confusion around player-facing services, test systems, telemetry pipelines, and live-ops infrastructure.

