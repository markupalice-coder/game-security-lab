#!/usr/bin/env bash
set -euo pipefail
required_files=(
"security/gitops-design.md"
"security/gitops-operating-contract.md"
"deploy/k8s/kustomization.yaml"
"deploy/gitops/argocd/game-api-application.yaml"
)
for file in "${required_files[@]}"; do
if [[ ! -f "$file" ]]; then
echo "Missing required GitOps file: $file"
exit 1
fi
done
grep -q "repoURL:" deploy/gitops/argocd/game-api-application.yaml
grep -q "targetRevision: main" deploy/gitops/argocd/game-api-application.yaml
grep -q "path: deploy/k8s" deploy/gitops/argocd/game-api-application.yaml
grep -q "namespace: game" deploy/gitops/argocd/game-api-application.yaml
kubectl kustomize deploy/k8s >/tmp/lab79-rendered.yaml
echo "GitOps design audit passed"
