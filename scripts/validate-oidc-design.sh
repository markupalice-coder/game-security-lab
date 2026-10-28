
#!/usr/bin/env bash

set -euo pipefail



test -f security/oidc-design.md

test -f security/oidc/aws/trust-policy.template.json

test -f security/oidc/aws/aws-oidc-workflow-example.yml

test -f security/oidc/aws/aws-console-setup-checklist.md

test -f .github/workflows/oidc-identity-preview.yml



python3 -m json.tool security/oidc/aws/trust-policy.template.json >/dev/null



grep -q "token.actions.githubusercontent.com:aud" security/oidc/aws/trust-policy.template.json

grep -q "token.actions.githubusercontent.com:sub" security/oidc/aws/trust-policy.template.json

grep -q "id-token: write" .github/workflows/oidc-identity-preview.yml

grep -q "No static cloud access key is stored" security/oidc-design.md



if grep -R "aws-access-key-id:\|aws-secret-access-key:" .github/workflows security/oidc --exclude-dir=.git; then

echo "Static AWS credential workflow pattern found. Replace it with OIDC."

exit 1

fi



echo "Lab 36 OIDC design audit passed."

