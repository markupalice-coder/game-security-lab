# 🎮 Game Security Lab
### DevSecOps Masterclass – Gaming Studios: Embedding Security

![Security](https://img.shields.io/badge/Focus-Game%20Security-blue)
![Labs](https://img.shields.io/badge/Labs-100-purple)
![DevSecOps](https://img.shields.io/badge/Domain-DevSecOps-green)
![GitHub Actions](https://img.shields.io/badge/Automation-GitHub%20Actions-black)

## 📌 Project Overview

**Game Security Lab** is a hands-on DevSecOps learning and implementation project focused on embedding security throughout the software development lifecycle of a modern gaming studio.

This repository documents a structured journey of **100 practical labs across 10 modules**, covering secure development, CI/CD security, vulnerability management, software supply chain security, infrastructure protection, Kubernetes, GitOps, runtime security, compliance, and sovereign release engineering.

The project follows a security-by-design approach, integrating automated security controls, policy enforcement, evidence collection, and developer-focused security practices.

The final objective is to build a **Secure Gaming Studio Release Control Plane** that brings security governance, automation, and release readiness together.

## 🎯 Project Objectives

- Establish a secure development environment and professional repository structure.
- Implement security-focused GitHub Actions workflows.
- Integrate Static Application Security Testing (SAST).
- Prevent accidental exposure of credentials and secrets.
- Manage dependencies, licenses, and Software Bills of Materials (SBOMs).
- Secure containers, infrastructure, and deployment pipelines.
- Implement Policy-as-Code and automated compliance checks.
- Introduce Kubernetes, GitOps, and runtime security practices.
- Standardize security findings, evidence, and remediation workflows.
- Build a comprehensive gaming studio release security control plane.

## 🗺️ 100-Lab Learning Roadmap

The following roadmap follows the supplied course directory and preserves its original lab numbering.

### Module 1 – Foundations, Local Environment, and Initial Success

| Lab | Title |
|---|---|
| 01 | Workstation Baseline |
| 02 | Minimal Game-Service Repository |
| 03 | Title pending |
| 04 | Create the First GitHub Actions Workflow |
| 05 | Reach the Initial Success Milestone |
| 06 | Title pending |
| 07 | Title pending |
| 08 | Enforce Signed Commit Awareness |
| 09 | Title pending |
| 10 | Create the First Pull Request Workflow |

### Module 2 – GitHub Actions Security Fundamentals

| Lab | Title |
|---|---|
| 11 | Pin Workflow Permissions to Least Privilege |
| 12 | Add a Workflow Lint Step |
| 13 | Add actionlint to GitHub Actions |
| 14 | Restrict Third-Party Actions by Policy |
| 15 | Create a Workflow Threat Model |
| 16 | Replace Inline Risky Shell With Script Files |
| 17 | Add Shell Safety Flags |
| 18 | Add Pull Request Metadata Safety |
| 19 | Add Concurrency Controls |
| 20 | Create a Reusable Security Workflow Skeleton |

### Module 3 – SAST for Game Clients, APIs, and Workflow Code

| Lab | Title |
|---|---|
| 21 | Add CodeQL for JavaScript and TypeScript |
| 22 | Add Semgrep Community SAST |
| 23 | Title pending |
| 24 | Remove the Debug Endpoint and Keep the Rule |
| 25 | Title pending |
| 26 | Title pending |
| 27 | Title pending |
| 28 | Title pending |
| 29 | Add Security Finding Triage Labels |
| 30 | Create a SAST Risk Acceptance Template |

### Module 4 – Secrets, Credentials, and Identity

| Lab | Title |
|---|---|
| 31 | Add Gitleaks Locally |
| 32 | Add Gitleaks Workflow Gate |
| 33 | Create a Safe Fake Secret Test |
| 34 | Add a Gitleaks Allowlist for Training Fixtures |
| 35 | Build a Secret Rotation Runbook |
| 36 | Replace Long-Lived Cloud Keys With OIDC Design |
| 37 | Add Environment Protection for Production |
| 38 | Create a Safe Deployment Workflow Placeholder |
| 39 | Add Secret Inventory Without Secret Values |
| 40 | Add Pre-Commit Hooks for Local Secret Prevention |

### Module 5 – Dependency, License, and SBOM Engineering

| Lab | Title |
|---|---|
| 41 | Add OSV-Scanner for npm Dependencies |
| 42 | Add npm Audit as a Secondary Signal |
| 43 | Configure Dependabot for npm |
| 44 | Generate a CycloneDX SBOM for the API |
| 45 | Add Syft SBOM Generation for the Repository |
| 46 | Scan the SBOM With Grype |
| 47 | Add SBOM Artifact Upload in GitHub Actions |
| 48 | Create a License Policy Baseline |
| 49 | Add Dependency Review Action for Pull Requests |
| 50 | Build the Dependency Risk Dashboard Markdown |

### Module 6 – Container, Game-Service, and Artifact Security

| Lab | Title |
|---|---|
| 51 | Containerize the Game API |
| 52 | Scan the Container With Trivy |
| 53 | Emit Trivy SARIF for GitHub Code Scanning |
| 54 | Harden the Dockerfile |
| 55 | Add Dockerfile Misconfiguration Scanning |
| 56 | Build Multi-Stage Container Image |
| 57 | Generate Container SBOM |
| 58 | Add Cosign Keyless Signing Design |
| 59 | Add Image Digest Discipline |
| 60 | Build a Release Artifact Manifest |

### Module 7 – Infrastructure as Code and Policy-as-Code

| Lab | Title |
|---|---|
| 61 | Add OpenTofu Infrastructure Skeleton |
| 62 | Scan IaC With Checkov |
| 63 | Add Checkov GitHub Actions Gate |
| 64 | Add Rego Policy for Required Environment Tags |
| 65 | Test Rego Policy With OPA |
| 66 | Add Conftest for Policy Testing |
| 67 | Add Passing Policy Fixture |
| 68 | Build Policy CI Gate |
| 69 | Map IaC Findings to Control Register |
| 70 | Create an IaC Exception Standard |

### Module 8 – Kubernetes, GitOps, Runtime Security, and Reliability

| Lab | Title |
|---|---|
| 71 | Title pending |
| 72 | Title pending |
| 73 | Harden Kubernetes Security Context |
| 74 | Add Resource Requests and Limits |
| 75 | Title pending |
| 76 | Create a Local Kind Cluster |
| 77 | Load and Deploy the Game API Locally |
| 78 | Title pending |
| 79 | Add Argo CD GitOps Design |
| 80 | Add Falco Runtime Detection Design |

### Module 9 – Scanner Orchestration, Evidence, and Developer Experience

| Lab | Title |
|---|---|
| 81 | Build a Unified Security Workflow |
| 82 | Add GitHub Step Summary for Scanner Results |
| 83 | Normalize Scanner Severity Rules |
| 84 | Add Warn-Only Mode for New Scanners |
| 85 | Create Security Evidence Bundle Script |
| 86 | Add Evidence Bundle Upload |
| 87 | Build Vulnerability SLA Rules |
| 88 | Add SARIF Retention Strategy |
| 89 | Add Developer Remediation Guide |

### Module 10 – Sovereign Deployment, Decentralized Research, and Final Capstone

| Lab | Title |
|---|---|
| 90 | Run a Full Security Control Review |
| 91 | Add Player Data Classification |
| 92 | Create Privacy-by-Design Telemetry Rules |
| 93 | Add Region-Aware Deployment Matrix Design |
| 94 | Add Decentralized Research Intake for New Threats |
| 95 | Add Scanner Evaluation Scorecard |
| 96 | Add AI-Assisted Workflow Safety Rules |
| 97 | Build Compliance Evidence Map |
| 98 | Add Sovereign Release Checklist |
| 99 | Run the Pre-Capstone Readiness Review |
| 100 | Capstone Project – Secure Gaming Studio Release Control Plane |

### Course Milestones

- Lab 1 – Workstation baseline established.
- Lab 2 – Initial game-service repository structure created.
- Lab 5 – Remote GitHub repository connected and initial CI verified.
- Lab 6 – Pull request requirements and passing CI configured.
- Lab 14 – Third-party GitHub Actions restricted by repository policy.
- Lab 18 – Pull request metadata safety testing.
- Lab 19 – Workflow concurrency controls tested.
- Lab 21 – CodeQL enabled for JavaScript and TypeScript.
- Lab 100 – Final secure gaming studio release control plane capstone.

*Note: The supplied course listing did not include titles for every intermediate lab. Those entries are intentionally marked as pending rather than assigned invented titles. Milestone descriptions reflect the recorded repository progress.*

## 🛠️ Technologies and Security Tools

| Category | Technologies |
|---|---|
| Version Control | Git, GitHub |
| CI/CD | GitHub Actions |
| Workflow Security | actionlint, OPA, Rego |
| SAST | CodeQL, Semgrep |
| Secret Detection | Gitleaks |
| Dependency Security | OSV-Scanner, npm Audit, Dependabot |
| SBOM Engineering | CycloneDX, Syft |
| Vulnerability Scanning | Grype, Trivy |
| Artifact Security | Cosign, SARIF |
| Container Security | Docker |
| Infrastructure as Code | OpenTofu, Checkov |
| Policy Testing | OPA, Conftest |
| Kubernetes | Kubernetes, Kind |
| GitOps | Argo CD |
| Runtime Security | Falco |
| Automation | Python, Shell Scripts |
| Governance | Control Registers, Evidence Bundles, Compliance Maps |

## 🏗️ Repository Architecture

```text
game-security-lab/
│
├── .github/
│   ├── workflows/
│   └── ISSUE_TEMPLATE/
│
├── src/
│   ├── api/
│   └── game-client/
│
├── infra/
│
├── policies/
│
├── scripts/
│
├── security/
│   ├── evidence/
│   ├── control-register.md
│   ├── threat-models/
│   ├── runbooks/
│   └── scanner-evaluations/
│
├── docs/
│
├── Dockerfile
├── README.md
└── requirements.txt
```

*The directory structure represents the main repository zones; individual directories may contain additional files and subdirectories.*

## 🔐 Security Engineering Principles

This project applies the following principles:

1. **Least Privilege:** Restrict workflow permissions and access to necessary resources.
2. **Defense in Depth:** Use multiple security scanners and complementary controls.
3. **Secure Software Supply Chain:** Track dependencies, generate SBOMs, and verify release artifacts.
4. **Security by Design:** Integrate security into development and deployment workflows.
5. **Policy as Code:** Define, test, and enforce security requirements automatically.
6. **Evidence-Based Compliance:** Maintain security evidence and map controls to documented requirements.
7. **Privacy by Design:** Protect player data and apply responsible telemetry practices.
8. **Human Oversight:** Require appropriate review for security exceptions and AI-assisted workflow decisions.

## 📊 Project Outcomes

The project aims to demonstrate practical experience in:

- Designing secure GitHub Actions pipelines.
- Integrating automated security scanning.
- Implementing secrets and credential protection.
- Managing software dependencies and SBOMs.
- Building container and infrastructure security controls.
- Applying Kubernetes and GitOps security principles.
- Developing reusable security automation.
- Creating security evidence and compliance documentation.
- Establishing vulnerability remediation and SLA processes.
- Engineering secure gaming studio release governance.

## 🏆 Final Capstone

### Secure Gaming Studio Release Control Plane

The final capstone integrates the security capabilities developed throughout the 100 labs into a unified release governance approach.

Its focus includes:

- Security control validation.
- Player data classification.
- Privacy-aware telemetry.
- Region-aware deployment design.
- Decentralized threat research intake.
- Scanner evaluation and severity normalization.
- AI-assisted workflow safety.
- Compliance evidence mapping.
- Sovereign release readiness.
- Final capstone readiness assessment.

## 📚 Learning Resources

The repository contains practical implementations, GitHub Actions workflows, scripts, policies, security documentation, and evidence artifacts developed throughout the learning journey.

Explore the repository directories to review individual implementations and their associated validation workflows.

## ⚠️ Disclaimer

This repository is intended for educational, research, and defensive security engineering purposes.

Security testing and vulnerability demonstrations should be performed only in authorized, isolated environments. Training fixtures and simulated credentials must not contain real secrets or production data.

## 👨‍💻 Project Repository

**Repository:** [shanukabherath-solutions/game-security-lab](https://github.com/shanukabherath-solutions/game-security-lab)

**Project:** Game Security Lab – DevSecOps Masterclass

**Scope:** 100 Labs | 10 Modules | Secure Gaming Studio Engineering

---

*Building security into every stage of the gaming software development lifecycle.*
