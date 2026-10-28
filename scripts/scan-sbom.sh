
#!/usr/bin/env bash

set -euo pipefail



SBOM_PATH="${1:-security/out/repo-sbom.cdx.json}"

FAIL_ON="${FAIL_ON:-high}"

OUT_DIR="${OUT_DIR:-security/out}"

GRYPE_IMAGE="${GRYPE_IMAGE:-anchore/grype:latest}"



TABLE_REPORT="${OUT_DIR}/grype-sbom-report.txt"

JSON_REPORT="${OUT_DIR}/grype-sbom-report.json"



if [[ ! -f "$SBOM_PATH" ]]; then

echo "ERROR: SBOM not found at: $SBOM_PATH"

echo "Fix: run ./scripts/generate-sbom.sh first."

exit 2

fi



mkdir -p "$OUT_DIR"



echo "Scanning SBOM: $SBOM_PATH"

echo "Failure threshold: $FAIL_ON"

echo "Human report: $TABLE_REPORT"

echo "JSON report: $JSON_REPORT"

echo



set +e

docker run --rm \

-v "$PWD:/work" \

-w /work \

"$GRYPE_IMAGE" \

"sbom:${SBOM_PATH}" \

--fail-on "$FAIL_ON" \

--output table | tee "$TABLE_REPORT"



SCAN_STATUS=${PIPESTATUS[0]}

set -e



docker run --rm \

-v "$PWD:/work" \

-w /work \

"$GRYPE_IMAGE" \

"sbom:${SBOM_PATH}" \

--output json > "$JSON_REPORT"



echo

echo "Grype table report saved to: $TABLE_REPORT"

echo "Grype JSON report saved to: $JSON_REPORT"



exit "$SCAN_STATUS"

