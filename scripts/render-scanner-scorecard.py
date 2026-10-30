#!/usr/bin/env python3
import json
from datetime import datetime, timezone
from pathlib import Path

INPUT = Path("security/scanner-evaluations/candidate-tools.json")
OUTPUT = Path("security/out/scanner-evaluation-scorecard.md")

LABELS = {
"open_source_usability": "Open-source usability",
"ci_reliability": "CI reliability",
"signal_quality": "Signal quality",
"sarif_or_artifact_support": "SARIF or artifact support",
"policy_control": "Policy control",
"runtime_cost": "Runtime cost",
"maintenance_health": "Maintenance health",
"gaming_relevance": "Gaming relevance"
}

def classify(score, minimum_adoption_score, warn_only_floor):
    if score >= minimum_adoption_score:
        return "Adopt / Standardize"
    if score >= warn_only_floor:
        return "Pilot / Warn-only"
    return "Reject / Re-evaluate Later"

def validate_score(tool_name, key, value):
    if not isinstance(value, int):
        raise SystemExit(f"{tool_name}: score for {key} must be an integer.")
    if value < 1 or value > 5:
        raise SystemExit(f"{tool_name}: score for {key} must be between 1 and 5.")

def main():
    if not INPUT.exists():
        raise SystemExit(f"Missing input file: {INPUT}")

    data = json.loads(INPUT.read_text(encoding="utf-8"))
    weights = data["weights"]
    candidates = data["candidates"]
    minimum_adoption_score = float(data.get("minimum_adoption_score", 4.0))
    warn_only_floor = float(data.get("warn_only_floor", 3.2))

    total_weight = sum(float(value) for value in weights.values())

    if total_weight < 0.99 or total_weight > 1.01:
        raise SystemExit(f"Weights must add up to 1.0. Current total: {total_weight:.2f}")

    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    lines = [
        "# Generated Scanner Evaluation Scorecard",
        "",
        f"Generated: {generated_at}",
        "",
        "## Decision Summary",
        "",
        "| Tool | Category | Weighted Score | Decision | Owner |",
        "|---|---|---:|---|---|"
    ]

    details = []

    for candidate in candidates:
        tool = candidate["tool"]
        category = candidate["category"]
        owner = candidate["owner"]
        scores = candidate["scores"]

        missing = [key for key in weights if key not in scores]

        if missing:
            raise SystemExit(f"{tool}: missing scores for {', '.join(missing)}")

        for key, value in scores.items():
            validate_score(tool, key, value)

        weighted_score = sum(scores[key] * weights[key] for key in weights)
        decision = classify(weighted_score, minimum_adoption_score, warn_only_floor)

        lines.append(
            f"| {tool} | {category} | {weighted_score:.2f} | {decision} | {owner} |"
        )

        details.extend([
            "",
            f"## {tool}",
            "",
            f"**Category:** {category}",
            "",
            f"**Source:** {candidate['source']}",
            "",
            f"**Owner:** {owner}",
            "",
            f"**Decision:** {decision}",
            "",
            f"**Weighted Score:** {weighted_score:.2f}",
            "",
            "### Criteria Scores",
            "",
            "| Criterion | Weight | Score |",
            "|---|---:|---:|"
        ])

        for key in weights:
            details.append(
                f"| {LABELS.get(key, key)} | {weights[key]:.2f} | {scores[key]} |"
            )

        details.extend([
            "",
            "### Evidence",
            "",
            candidate["evidence"],
            "",
            "### Decision Notes",
            "",
            candidate["decision_notes"],
            ""
        ])

    lines.extend(details)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"Wrote {OUTPUT}")

if __name__ == "__main__":
    main()
