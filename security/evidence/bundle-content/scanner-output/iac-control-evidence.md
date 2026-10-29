# IaC Control Evidence Report

Generated UTC: 2026-10-29T11:44:22Z

## Purpose

This report maps infrastructure-as-code scanner evidence to named security controls in the control register.

## Control Map

| Control ID | Control Name | Scanner | Owner | Required Response |
| --- | --- | --- | --- | --- |
| IAC-001 | IaC Misconfiguration Baseline | Checkov | Platform Team | Remediate unsafe configuration or document a future exception. |
| IAC-002 | Studio-Specific Policy Enforcement | Conftest with OPA/Rego | Security Team | Fix the policy violation or assign an accountable owner. |
| IAC-003 | Finding Accountability | Governance Review | Security and Platform Leads | Every finding must include severity, owner, remediation, and exception expiry when accepted. |

## Scanner Findings Mapped to Controls

| Control ID | Scanner | Rule | Severity | Resource | File | Message |
| --- | --- | --- | --- | --- | --- | --- |
| IAC-002 | Conftest/OPA | rego-deny | POLICY | policy fixture | policy fixture | service must include environment tag |

## Required Governance Fields

| Field | Required |
| --- | --- |
| control_id | Yes |
| scanner | Yes |
| severity | Yes |
| owner | Yes |
| remediation | Yes |
| exception_expiry | Yes |

## Lab 69 Result

IaC findings are now connected to the control register through both human-readable and machine-readable evidence.
