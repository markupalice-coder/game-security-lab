#!/usr/bin/env bash
set -euo pipefail

SBOM_PATH="${1:-security/out/repo-sbom.cdx.json}"
FAIL_ON="${FAIL_ON:-high}"
OUT_DIR="${OUT_DIR:-security/out}"
GRYPE_IMAGE="${GRYPE_IMAGE:-anchore/grype:latest}"

TABLE_REPORT="$OUT_DIR/grype-sbom-report.txt"
JSON_REPORT="$OUT_DIR/grype-sbom-report.json"

if [[ ! -s "$SBOM_PATH" ]]; then
  echo "ERROR: SBOM missing or empty: $SBOM_PATH"
  exit 2
fi

mkdir -p "$OUT_DIR"
HOST_DIR="$(pwd -W)"

echo "Scanning SBOM: $SBOM_PATH"
echo "Failure threshold: $FAIL_ON"

set +e
MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$HOST_DIR:/work:ro" \
  -w /work \
  "$GRYPE_IMAGE" \
  "sbom:$SBOM_PATH" \
  --fail-on "$FAIL_ON" \
  --output table | tee "$TABLE_REPORT"

SCAN_STATUS=${PIPESTATUS[0]}
set -e

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$HOST_DIR:/work:ro" \
  -w /work \
  "$GRYPE_IMAGE" \
  "sbom:$SBOM_PATH" \
  --output json > "$JSON_REPORT"

echo "Table report: $TABLE_REPORT"
echo "JSON report: $JSON_REPORT"

exit "$SCAN_STATUS"
