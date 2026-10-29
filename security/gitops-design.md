
# GitOps Design



## Purpose



The game API must be deployed from Git-approved Kubernetes manifests, not from undocumented manual cluster changes.



## Source of Truth



Git is the desired state.



## Deployment Flow



1. Developers change Kubernetes manifests in `deploy/k8s`.

2. Security scanners run before manifest merge.

3. Pull requests require review before changes reach `main`.

4. Argo CD watches approved deployment paths.

5. Argo CD compares live cluster state against Git state.

6. Rollback means reverting Git to a known good commit.



## Production Rule



Production sync requires signed artifacts, approved environments, vulnerability gates, and no raw secret values in Git.



## Human Rule



Humans may inspect the cluster with `kubectl`, but production changes must come from Git.

