package gaming.tags

import rego.v1

deny contains msg if {
    input.resource_type == "service"
    not input.tags.environment

    msg := "service must include environment tag"
}
