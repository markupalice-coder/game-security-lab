
#!/usr/bin/env bash

set -euo pipefail



WORKFLOW_DIR=".github/workflows"

failures=0



echo "Auditing GitHub Actions pull request metadata safety..."



if [[ ! -d "$WORKFLOW_DIR" ]]; then

echo "::error::Workflow directory not found: $WORKFLOW_DIR"

exit 1

fi



echo "Check 1: Searching for pull_request_target..."

if grep -RIn --include='*.yml' --include='*.yaml' "pull_request_target:" "$WORKFLOW_DIR"; then

echo "::error::pull_request_target detected. Do not use it with untrusted pull request code."

failures=1

else

echo "Passed: No pull_request_target trigger found."

fi



echo "Check 2: Searching for direct GitHub context interpolation in run commands..."

if grep -RInE --include='*.yml' --include='*.yaml' 'run:.*\$\{\{\s*github\.(event|head_ref|base_ref)' "$WORKFLOW_DIR"; then

echo "::error::GitHub context appears directly inside a run command."

echo "::error::Move metadata into env and quote it inside a script."

failures=1

else

echo "Passed: No obvious direct GitHub context interpolation inside one-line run commands."

fi



echo "Check 3: Searching for pull request metadata references..."

if grep -RInE --include='*.yml' --include='*.yaml' '\$\{\{\s*github\.event\.pull_request\.(title|body|head\.ref|head\.label|base\.ref|labels|user\.login)' "$WORKFLOW_DIR"; then

echo "::warning::Pull request metadata is referenced. Confirm it is treated as data, not executable code."

else

echo "Passed: No pull request metadata references found."

fi



if [[ "$failures" -ne 0 ]]; then

echo "Pull request metadata safety audit failed."

exit 1

fi



echo "Pull request metadata safety audit passed."

