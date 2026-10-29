#!/usr/bin/env python3

import json
from pathlib import Path

path = Path("security/out/game-api.spdx.json")

data = json.loads(path.read_text(encoding="utf-8"))

packages = data.get("packages", [])

print("# Container SBOM Audit Summary")
print()
print(f"SBOM file: {path}")
print(f"SPDX version: {data.get('spdxVersion')}")
print(f"Document name: {data.get('name')}")
print(f"Package count: {len(packages)}")
print()

print("First 20 package names:")

for package in packages[:20]:
    print(f"- {package.get('name', '<unnamed>')}")
