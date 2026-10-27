
# Pull Request Metadata Safety Policy



## Purpose



Pull request metadata must be treated as untrusted input. This includes pull request titles, bodies, branch names, labels, usernames, comments, and issue text.



## Rules



1. Do not use pull_request_target for workflows that check out, build, test, install, or execute pull request code.

2. Do not place github.event pull request fields directly inside run commands.

3. Use pull_request for normal CI checks.

4. Use read-only GITHUB_TOKEN permissions for pull request validation jobs.

5. If metadata must be read, pass it through env and quote it inside scripts.

6. Never expose repository secrets to forked pull request workflows.

7. If a privileged workflow is needed for labeling or commenting, it must not check out or execute untrusted pull request code.



## Safe Pattern



Use pull_request for untrusted code validation.



Use pull_request_target only for narrow metadata-only automation, such as labeling, and only when the workflow does not check out or execute pull request code.



## Unsafe Pattern



Do not combine pull_request_target with actions/checkout of the pull request head SHA and build/test commands.

