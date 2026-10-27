
# Security Control Register



| Control | Purpose | Tool | Gate | Evidence | Current Status |

|---|---|---|---|---|---|

| SAST | Detect insecure source-code patterns before merge | CodeQL and Semgrep | Pull request | SARIF | Planned |

| Secrets | Prevent credentials from entering repository history | Gitleaks | Pull request | JSON report | Planned |

| SCA | Detect vulnerable open-source dependencies | OSV-Scanner and Trivy | Pull request | SARIF and vulnerability table | Planned |

| IaC | Detect unsafe infrastructure definitions before deployment | Checkov and Conftest | Pull request | SARIF and workflow logs | Planned |

| Supply Chain | Prove what was built, from which source, and by which workflow | SBOM, cosign, and SLSA | Release | Signed artifacts and provenance | Planned |

