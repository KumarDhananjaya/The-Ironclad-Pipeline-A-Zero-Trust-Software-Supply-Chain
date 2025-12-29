#!/bin/bash
# Setup Vault and inject dummy secrets

echo "Installing Vault via Helm..."
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault --namespace vault --create-namespace --set "server.dev.enabled=true"

echo "Waiting for Vault to be ready..."
kubectl wait --for=condition=Ready pod/vault-0 -n vault --timeout=60s

echo "Injecting sample secrets..."
kubectl exec -n vault vault-0 -- vault kv put secret/ironclad-app db-password="super-secret-password"
