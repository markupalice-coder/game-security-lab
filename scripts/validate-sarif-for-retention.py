#!/usr/bin/env python3

import json
import re
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 2:
        print(
            "Usage: validate-sarif-for-retention.py <file.sarif>",
            file=sys.stderr,
        )
        return 2

    sarif_path = Path(sys.argv[1])

    if not sarif_path.is_file():
        print(
            f"ERROR: SARIF file not found: {sarif_path}",
            file=sys.stderr,
        )
        return 1

    try:
        data = json.loads(sarif_path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError, OSError) as exc:
        print(f"ERROR: Unable to read valid SARIF JSON: {exc}", file=sys.stderr)
        return 1

    if not isinstance(data, dict):
        print("ERROR: SARIF root must be a JSON object.", file=sys.stderr)
        return 1

    if data.get("version") != "2.1.0":
        print("ERROR: SARIF version must be 2.1.0.", file=sys.stderr)
        return 1

    runs = data.get("runs")

    if not isinstance(runs, list) or not runs:
        print(
            "ERROR: SARIF file must contain at least one run.",
            file=sys.stderr,
        )
        return 1

    raw = json.dumps(data, ensure_ascii=True)

    secret_patterns = {
        "AWS access key": r"AKIA[0-9A-Z]{16}",
        "GitHub token": r"gh[pousr]_[A-Za-z0-9_]{36,}",
        "Private key": r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
        "Slack token": r"xox[baprs]-[A-Za-z0-9-]{20,}",
    }

    for name, pattern in secret_patterns.items():
        if re.search(pattern, raw):
            print(
                f"ERROR: Possible secret detected in SARIF: {name}",
                file=sys.stderr,
            )
            return 1

    print(
        f"SARIF retention check passed: {sarif_path} "
        f"({len(runs)} run group(s))"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
