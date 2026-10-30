package main

import rego.v1

required_scanners contains "codeql"
required_scanners contains "semgrep"
required_scanners contains "gitleaks"
required_scanners contains "osv"
required_scanners contains "dependency-review"
required_scanners contains "container-scan"
required_scanners contains "iac-scan"

scanner_is_configured(scanner) if {
input.scanners_required[_] == scanner
}

missing_scanners contains scanner if {
required_scanners[scanner]
not scanner_is_configured(scanner)
}

deny contains msg if {
input.allowed_agent_write_access == true
msg := "AI agents must not have default repository write access."
}

deny contains msg if {
input.production_secret_access == true
msg := "AI agents must not access production secrets."
}

deny contains msg if {
input.human_approval_required != true
msg := "Human approval is required before AI-generated changes can merge."
}

deny contains msg if {
input.agent_self_approval_allowed == true
msg := "AI agents must not approve their own pull requests."
}

deny contains msg if {
input.agent_production_deploy_allowed == true
msg := "AI agents must not deploy to production."
}

deny contains msg if {
input.agent_release_publish_allowed == true
msg := "AI agents must not publish releases."
}

deny contains msg if {
input.agent_workflow_edit_without_codeowner_allowed == true
msg := "AI agents must not edit workflows without code-owner review."
}

deny contains msg if {
input.prompt_log_retention_days > 30
msg := "AI prompt and tool logs must not exceed the approved retention window."
}

deny contains msg if {
count(missing_scanners) > 0
msg := sprintf("Missing required scanner gates: %v", [missing_scanners])
}

deny contains msg if {
input.exception_requirements.owner_required != true
msg := "AI safety exceptions must require an owner."
}

deny contains msg if {
input.exception_requirements.expiry_required != true
msg := "AI safety exceptions must require an expiry date."
}

deny contains msg if {
input.exception_requirements.compensating_control_required != true
msg := "AI safety exceptions must require a compensating control."
}

deny contains msg if {
input.exception_requirements.security_review_required != true
msg := "AI safety exceptions must require security review."
}

