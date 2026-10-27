
#!/usr/bin/env bash

set -euo pipefail



semgrep scan \

--config p/owasp-top-ten \

--config security/semgrep \

--error \

.

