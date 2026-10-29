#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="game-lab"
CONFIG_FILE="infra/kind/game-lab.yaml"

echo "Checking Docker connectivity..."
docker info >/dev/null

echo "Checking whether Kind cluster already exists..."
if kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  echo "Kind cluster '${CLUSTER_NAME}' already exists. Skipping creation."
else
  echo "Creating Kind cluster '${CLUSTER_NAME}'..."
  kind create cluster --config "${CONFIG_FILE}" --wait 120s
fi

echo "Switching kubectl context..."
kubectl config use-context "kind-${CLUSTER_NAME}"

echo "Cluster information:"
kubectl cluster-info --context "kind-${CLUSTER_NAME}"

echo "Node status:"
kubectl get nodes -o wide
