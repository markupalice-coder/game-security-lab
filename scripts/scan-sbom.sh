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

host_path() {
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) pwd -W ;;
    *) pwd -P ;;
  esac
}

HOST_DIR="$(host_path)"
HOST_OUT_DIR="$(cd "$OUT_DIR" && host_path)"

echo "Scanning SBOM: $SBOM_PATH"
echo "Failure threshold: $FAIL_ON"
echo "Using persistent Grype database cache"

rm -f "$JSON_REPORT"

set +e

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$HOST_DIR:/work:ro" \
  -v "$HOST_OUT_DIR:/out" \
  -v "grype-db-cache:/cache" \
  -e GRYPE_DB_CACHE_DIR=/cache \
  -e GRYPE_DB_UPDATE_DOWNLOAD_TIMEOUT=15m \
  -e GRYPE_CHECK_FOR_APP_UPDATE=false \
  -w /work \
  "$GRYPE_IMAGE" \
  "sbom:$SBOM_PATH" \
  --fail-on "$FAIL_ON" \
  --output table \
  --output json=/out/grype-sbom-report.json \
  | tee "$TABLE_REPORT"

SCAN_STATUS=${PIPESTATUS[0]}

set -e

if [[ -s "$JSON_REPORT" ]]; then
  echo "Table report: $TABLE_REPORT"
  echo "JSON report: $JSON_REPORT"
else
  echo "ERROR: JSON report was not generated"
fi

if [[ "$SCAN_STATUS" -eq 0 ]]; then
  echo "SBOM vulnerability scan passed"
elif [[ "$SCAN_STATUS" -eq 2 ]]; then
  echo "SBOM scan found vulnerabilities at or above $FAIL_ON"
else
  echo "ERROR: Grype scan failed (exit code $SCAN_STATUS)"
fi

exit "$SCAN_STATUS"
