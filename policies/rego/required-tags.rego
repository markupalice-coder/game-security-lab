package gaming.tags

deny contains msg if {
    input.resource_type == "service"
    not input.tags.environment
    msg := "service must include environment tag"
}
