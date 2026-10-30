package main

required_collect := {
    "event_type",
    "region",
    "platform",
    "client_version",
    "timestamp",
}

required_avoid := {
    "raw_chat",
    "precise_location",
    "government_id",
    "payment_card",
    "full_ip_address",
    "email_address",
    "real_name",
    "anti_cheat_secret",
    "signing_key",
}

deny contains msg if {
    not input.telemetry
    msg := "telemetry root object is required"
}

deny contains msg if {
    some field in required_collect
    not field in input.telemetry.collect_only
    msg := sprintf("Required safe telemetry field %q is missing from telemetry.collect_only.", [field])
}

deny contains msg if {
    some field in required_avoid
    not field in input.telemetry.avoid
    msg := sprintf("Required prohibited telemetry field %q is missing from telemetry.avoid.", [field])
}

deny contains msg if {
    some field in input.telemetry.collect_only
    field in input.telemetry.avoid
    msg := sprintf("Telemetry field %q cannot appear in both collect_only and avoid.", [field])
}

deny contains msg if {
    input.telemetry.retention_days.raw > 30
    msg := "Raw telemetry retention must be 30 days or less."
}

deny contains msg if {
    input.telemetry.retention_days.aggregate > 365
    msg := "Aggregate telemetry retention must be 365 days or less."
}

deny contains msg if {
    input.telemetry.retention_days.raw > input.telemetry.retention_days.aggregate
    msg := "Raw telemetry retention cannot be longer than aggregate telemetry retention."
}

deny contains msg if {
    input.telemetry.defaults.pseudonymize_player_id != true
    msg := "Player identifiers must be pseudonymized by default."
}

deny contains msg if {
    input.telemetry.defaults.precise_location_allowed != false
    msg := "Precise location must be disabled by default."
}

deny contains msg if {
    input.telemetry.defaults.raw_chat_allowed != false
    msg := "Raw chat collection must be disabled by default."
}

deny contains msg if {
    input.telemetry.defaults.payment_data_allowed != false
    msg := "Payment data collection must be disabled by default."
}

deny contains msg if {
    input.telemetry.defaults.secret_collection_allowed != false
    msg := "Secrets must never be collected through telemetry."
}

deny contains msg if {
    input.telemetry.review.approval_required_for_new_fields != true
    msg := "New telemetry fields must require approval."
}

deny contains msg if {
    input.telemetry.review.expiry_required_for_exceptions != true
    msg := "Telemetry exceptions must include an expiry date."
}

deny contains msg if {
    input.telemetry.review.owner_required_for_exceptions != true
    msg := "Telemetry exceptions must include an accountable owner."
}

