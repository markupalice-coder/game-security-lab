
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

EVIDENCE_ROOT="security/evidence"
BUNDLE_CONTENT="$EVIDENCE_ROOT/bundle-content"
SCANNER_OUTPUT="$BUNDLE_CONTENT/scanner-output"
BUNDLE_FILE="security/evidence-bundle.tgz"

rm -rf "$BUNDLE_CONTENT"
mkdir -p "$SCANNER_OUTPUT"

copy_if_exists() {
  local source_path="$1"
  local destination_path="$2"

  if [[ -e "$source_path" ]]; then
    mkdir -p "$(dirname "$destination_path")"
    cp -R "$source_path" "$destination_path"
    echo "Collected: $source_path"
  else
    echo "Skipped missing file: $source_path"
  fi
}

copy_if_exists "security/control-register.md" "$BUNDLE_CONTENT/control-register.md"
copy_if_exists "security/severity-policy.yml" "$BUNDLE_CONTENT/severity-policy.yml"
copy_if_exists "security/vulnerability-sla.yml" "$BUNDLE_CONTENT/vulnerability-sla.yml"

if [[ -d "security/out" ]]; then
  cp -R security/out/. "$SCANNER_OUTPUT/"
  echo "Collected scanner outputs from security/out"
else
  echo "No security/out directory found"
fi

cat > "$BUNDLE_CONTENT/evidence-manifest.md" <<MANIFEST
# Security Evidence Bundle Manifest

Generated UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)

Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "not-a-git-repository")

Git Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

Repository Root: $PROJECT_ROOT

## Purpose

This bundle preserves security evidence for release review, audit review, incident review, and scanner rollout governance.

## Expected Contents

- control-register.md
- severity-policy.yml
- vulnerability-sla.yml
- scanner-output/
- SHA256SUMS
- evidence-manifest.md

## Lab Context

Lab 85 creates the local evidence bundle.

Lab 86 will upload this bundle as retained CI evidence.
MANIFEST

if command -v sha256sum >/dev/null 2>&1; then
  find "$BUNDLE_CONTENT" -type f ! -name "SHA256SUMS" -print0 |
    sort -z |
    xargs -0 sha256sum > "$BUNDLE_CONTENT/SHA256SUMS"
else
  find "$BUNDLE_CONTENT" -type f ! -name "SHA256SUMS" -print0 |
    sort -z |
    xargs -0 shasum -a 256 > "$BUNDLE_CONTENT/SHA256SUMS"
fi

rm -f "$BUNDLE_FILE"
tar -czf "$BUNDLE_FILE" -C "$EVIDENCE_ROOT" bundle-content

echo
echo "Evidence bundle created:"
ls -lh "$BUNDLE_FILE"
