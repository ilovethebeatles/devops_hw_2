#!/usr/bin/env bash
set -euo pipefail

if ! command -v istioctl &> /dev/null; then
  echo "istioctl not found. Downloading Istio CLI..."
  curl -L https://istio.io/downloadIstio | sh -
  ISTIO_ROOT=$(find . -maxdepth 1 -type d -name 'istio-*' | head -n1)
  export PATH="$PWD/$ISTIO_ROOT/bin:$PATH"
fi

echo "=== Installing Istio service mesh ==="
istioctl install --set profile=demo -y

echo "=== Enabling sidecar injection in default namespace ==="
kubectl label namespace default istio-injection=enabled --overwrite

echo "=== Applying Istio manifests ==="
for mf in kubernetes/istio/*.yaml; do
  echo " - Applying $mf"
  kubectl apply -f "$mf"
done

echo "=== Deploying Kubernetes manifests ==="
while IFS= read -r -d '' mf; do
  echo " - Applying $mf"
  kubectl apply -f "$mf"
done < <(find kubernetes -type f \( -iname '*.yaml' -o -iname '*.yml' \) -not -path '*/istio/*' -print0)

echo "Waiting for application rollout..."
kubectl rollout status deployment/custom-app

echo "All resources created."
