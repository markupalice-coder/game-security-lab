
#!/usr/bin/env bash

set -euo pipefail



PR_TITLE="${PR_TITLE:-not-a-pull-request}"

PR_AUTHOR="${PR_AUTHOR:-unknown-author}"



printf 'Pull request author: %s\n' "$PR_AUTHOR"

printf 'Pull request title received as plain text: %s\n' "$PR_TITLE"

