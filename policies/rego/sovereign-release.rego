package main

deny[msg] {
    input.release.target_region == ""
    msg := "release.target_region must be set"
}

deny[msg] {
    not input.regional_governance.region_selected_and_approved
    msg := "region must be selected and approved"
}

deny[msg] {
    input.regional_governance.regional_data_owner == ""
    msg := "regional data owner must be identified"
}

deny[msg] {
    not input.regional_governance.player_data_class_reviewed
    msg := "player data class must be reviewed"
}

deny[msg] {
    not input.regional_governance.telemetry_fields_approved
    msg := "telemetry fields must be approved"
}

deny[msg] {
    not input.security_supply_chain.secrets_regional_or_short_lived
    msg := "secrets must be regional or short-lived"
}

deny[msg] {
    not input.security_supply_chain.sbom_generated_and_retained
    msg := "SBOM must be generated and retained"
}

deny[msg] {
    not input.security_supply_chain.image_signed_or_exception_approved
    msg := "image must be signed or have an approved signing exception"
}

deny[msg] {
    not input.security_supply_chain.vulnerabilities_meet_sla
    msg := "vulnerabilities must meet the release SLA"
}

deny[msg] {
    input.rollback_incident.rollback_commit == ""
    msg := "rollback commit must be recorded"
}

deny[msg] {
    startswith(input.rollback_incident.rollback_commit, "REPLACE_")
    msg := "rollback commit still contains a placeholder"
}

deny[msg] {
    not startswith(input.rollback_incident.image_digest, "sha256:")
    msg := "image digest must start with sha256:"
}

deny[msg] {
    input.rollback_incident.incident_contact_path == ""
    msg := "incident contact path must be confirmed"
}

deny[msg] {
    input.final_decision.approved_for_sovereign_release
    input.final_decision.blocked_pending_remediation
    msg := "release cannot be both approved and blocked"
}

deny[msg] {
    input.final_decision.approved_with_time_bound_exception
    input.final_decision.exception_expiry_date == ""
    msg := "time-bound exception requires an expiry date"
}

deny[msg] {
    input.final_decision.approved_with_time_bound_exception
    input.final_decision.exception_owner == ""
    msg := "time-bound exception requires an owner"
}

deny[msg] {
    input.final_decision.approved_with_time_bound_exception
    input.final_decision.compensating_control == ""
    msg := "time-bound exception requires a compensating control"
}
