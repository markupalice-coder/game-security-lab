
#!/usr/bin/env bash

set -euo pipefail



OWNER_REPO="${OWNER_REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"

WORKFLOW_NAME="${WORKFLOW_NAME:-cosign-keyless-signing.yml}"

BRANCH="${BRANCH:-main}"

IMAGE_URI="${1:-ghcr.io/${OWNER_REPO}/game-api:sha-placeholder}"



cat <<PREVIEW

Future signing command:



cosign sign --yes "${IMAGE_URI}"



Future verification command:



cosign verify "${IMAGE_URI}" \\

--certificate-identity="https://github.com/${OWNER_REPO}/.github/workflows/${WORKFLOW_NAME}@refs/heads/${BRANCH}" \\

--certificate-oidc-issuer="https://token.actions.githubusercontent.com"



Lab 58 note:

This is a command preview only. Do not treat this as a production signing workflow yet.

PREVIEW

