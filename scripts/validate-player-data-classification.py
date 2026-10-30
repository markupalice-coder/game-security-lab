#!/usr/bin/env python3

import json
import sys
from pathlib import Path

EXPECTED_CLASSES = ["public", "internal", "confidential", "restricted"]

REQUIRED_CLASS_FIELDS = {
    "rank",
    "description",
    "examples",
    "controls"
}

REQUIRED_CONTROLS = {
    "collection_minimization",
    "access_control",
    "encryption_in_transit",
    "encryption_at_rest",
    "retention_days",
    "access_logging",
    "security_review"
}


def fail(message: str) -> None:
    print(f"FAILED: {message}")
    sys.exit(1)


def main() -> None:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("security/player-data-classification.json")

    if not path.exists():
        fail(f"Missing classification file: {path}")

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        fail(f"Invalid JSON in {path}: line {error.lineno}, column {error.colno}: {error.msg}")

    if data.get("schema_version") != "1.0":
        fail("schema_version must be 1.0")

    if data.get("policy_name") != "Player Data Classification":
        fail("policy_name must be Player Data Classification")

    classes = data.get("classes")

    if not isinstance(classes, dict):
        fail("classes must be an object")

    actual_classes = list(classes.keys())

    if actual_classes != EXPECTED_CLASSES:
        fail(f"classes must appear in this exact order: {EXPECTED_CLASSES}")

    previous_rank = 0
    previous_retention = None

    for class_name in EXPECTED_CLASSES:
        item = classes[class_name]

        if not isinstance(item, dict):
            fail(f"{class_name} must be an object")

        missing_fields = REQUIRED_CLASS_FIELDS - item.keys()

        if missing_fields:
            fail(f"{class_name} is missing fields: {sorted(missing_fields)}")

        rank = item["rank"]

        if not isinstance(rank, int) or isinstance(rank, bool):
            fail(f"{class_name}.rank must be an integer")

        if rank <= previous_rank:
            fail(f"{class_name}.rank must be stricter than the previous class")

        previous_rank = rank

        examples = item["examples"]

        if not isinstance(examples, list) or len(examples) < 3:
            fail(f"{class_name}.examples must contain at least three examples")

        controls = item["controls"]

        if not isinstance(controls, dict):
            fail(f"{class_name}.controls must be an object")

        missing_controls = REQUIRED_CONTROLS - controls.keys()

        if missing_controls:
            fail(f"{class_name}.controls is missing controls: {sorted(missing_controls)}")

        retention_days = controls["retention_days"]

        if not isinstance(retention_days, int) or isinstance(retention_days, bool) or retention_days <= 0:
            fail(f"{class_name}.controls.retention_days must be a positive integer")

        if previous_retention is not None and retention_days > previous_retention and class_name in {"confidential", "restricted"}:
            fail(f"{class_name} retention should not be longer than the less-sensitive class before it")

        previous_retention = retention_days

    restricted_controls = classes["restricted"]["controls"]

    if restricted_controls["encryption_at_rest"] != "required":
        fail("restricted data must require encryption at rest")

    if restricted_controls["access_logging"] != "required":
        fail("restricted data must require access logging")

    if restricted_controls["security_review"] != "required":
        fail("restricted data must require security review")

    print("Player data classification validation passed.")
    print("Validated classes: public, internal, confidential, restricted.")


if __name__ == "__main__":
    main()
