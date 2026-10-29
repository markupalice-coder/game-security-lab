#!/usr/bin/env python3
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(".")
OUT = ROOT / "security" / "out"
CONTROL_MAP = ROOT / "security" / "iac-control-map.json"
CHECKOV_JSON = OUT / "checkov-iac.json"
CONFTEST_JSON = OUT / "conftest-iac.json"
REPORT = OUT / "iac-control-evidence.md"

def load_json(path):
    if not path.exists():
        return None
    text = path.read_text(encoding="utf-8").strip()
    if not text:
        return None
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return {"_parse_error": f"{path} did not contain valid JSON"}

def collect_checkov_findings(data):
    findings = []
    if not isinstance(data, dict):
        return findings
    results = data.get("results", {})
    failed_checks = results.get("failed_checks", [])
    for item in failed_checks:
        findings.append({
            "control_id": "IAC-001",
            "scanner": "Checkov",
            "rule": item.get("check_id", "unknown"),
            "severity": item.get("severity", "UNKNOWN"),
            "resource": item.get("resource", "unknown"),
            "file": item.get("file_path", "unknown"),
            "message": item.get("check_name", "IaC misconfiguration detected")
        })
    return findings

def collect_conftest_failures(data):
    failures = []
    def walk(value):
        if isinstance(value, dict):
            if "msg" in value:
                failures.append({
                    "control_id": "IAC-002",
                    "scanner": "Conftest/OPA",
                    "rule": value.get("metadata", {}).get("code", "rego-deny"),
                    "severity": "POLICY",
                    "resource": value.get("filename", "policy fixture"),
                    "file": value.get("filename", "policy fixture"),
                    "message": str(value.get("msg", "Policy violation detected"))
                })
            for nested in value.values():
                walk(nested)
        elif isinstance(value, list):
            for item in value:
                walk(item)
    walk(data)
    return failures

def markdown_table(headers, rows):
    lines = []
    lines.append("| " + " | ".join(headers) + " |")
    lines.append("| " + " | ".join(["---"] * len(headers)) + " |")
    for row in rows:
        safe = [str(cell).replace("\n", " ").replace("|", "\\|") for cell in row]
        lines.append("| " + " | ".join(safe) + " |")
    return "\n".join(lines)

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    control_map = load_json(CONTROL_MAP) or {}
    checkov_data = load_json(CHECKOV_JSON)
    conftest_data = load_json(CONFTEST_JSON)
    controls = control_map.get("controls", [])
    findings = []
    findings.extend(collect_checkov_findings(checkov_data))
    findings.extend(collect_conftest_failures(conftest_data))
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    lines = [
        "# IaC Control Evidence Report",
        "",
        f"Generated UTC: {now}",
        "",
        "## Purpose",
        "",
        "This report maps infrastructure-as-code scanner evidence to named security controls in the control register.",
        "",
        "## Control Map",
        ""
    ]
    control_rows = [
        [
            c.get("control_id", ""),
            c.get("control_name", ""),
            c.get("scanner", ""),
            c.get("owner", ""),
            c.get("required_response", "")
        ]
        for c in controls
    ]
    lines.append(markdown_table(
        ["Control ID", "Control Name", "Scanner", "Owner", "Required Response"],
        control_rows
    ))
    lines.extend([
        "",
        "## Scanner Findings Mapped to Controls",
        ""
    ])
    if findings:
        finding_rows = [
            [
                f["control_id"],
                f["scanner"],
                f["rule"],
                f["severity"],
                f["resource"],
                f["file"],
                f["message"]
            ]
            for f in findings
        ]
        lines.append(markdown_table(
            ["Control ID", "Scanner", "Rule", "Severity", "Resource", "File", "Message"],
            finding_rows
        ))
    else:
        lines.append("No mapped IaC findings were detected in the current evidence files.")
    lines.extend([
        "",
        "## Required Governance Fields",
        "",
        markdown_table(
            ["Field", "Required"],
            [[field, "Yes"] for field in control_map.get("required_finding_fields", [])]
        ),
        "",
        "## Lab 69 Result",
        "",
        "IaC findings are now connected to the control register through both human-readable and machine-readable evidence."
    ])
    REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {REPORT}")

if __name__ == "__main__":
    main()
