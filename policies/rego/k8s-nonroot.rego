package k8s.security

deny contains msg if {
    input.kind == "Deployment"
    not input.spec.template.spec.securityContext.runAsNonRoot
    msg := sprintf("deployment/%s must set spec.template.spec.securityContext.runAsNonRoot: true", [input.metadata.name])
}

deny contains msg if {
    input.kind == "Deployment"
    input.spec.template.spec.securityContext.runAsUser == 0
    msg := sprintf("deployment/%s must not set pod-level runAsUser: 0", [input.metadata.name])
}

deny contains msg if {
    input.kind == "Deployment"
    some i
    container := input.spec.template.spec.containers[i]
    container.securityContext.runAsNonRoot == false
    msg := sprintf("container/%s in deployment/%s must not set runAsNonRoot: false", [container.name, input.metadata.name])
}

deny contains msg if {
    input.kind == "Deployment"
    some i
    container := input.spec.template.spec.containers[i]
    container.securityContext.runAsUser == 0
    msg := sprintf("container/%s in deployment/%s must not run as UID 0", [container.name, input.metadata.name])
}
