package sovereign.matrix

deny contains msg if {
    some region
    cfg := input.regions[region]
    not cfg.github_environment
    msg := sprintf("region %s must define a GitHub Environment", [region])
}

deny contains msg if {
    some region
    cfg := input.regions[region]
    cfg.logs != "regional"
    msg := sprintf("region %s must keep logs regional", [region])
}

deny contains msg if {
    some region
    cfg := input.regions[region]
    cfg.secrets_scope != "environment"
    msg := sprintf("region %s must use environment-scoped secrets", [region])
}

deny contains msg if {
    some region
    cfg := input.regions[region]
    cfg.sbom_evidence != "regional"
    msg := sprintf("region %s must keep SBOM evidence region-aware", [region])
}

deny contains msg if {
    some region
    cfg := input.regions[region]
    cfg.raw_telemetry_retention_days > 30
    msg := sprintf("region %s raw telemetry retention must not exceed 30 days", [region])
}

deny contains msg if {
    some region
    cfg := input.regions[region]
    count(cfg.deployment_approvers) == 0
    msg := sprintf("region %s must define at least one deployment approver", [region])
}
