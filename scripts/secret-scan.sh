#!/bin/bash
# Gitleaks scan script

echo "Running Gitleaks scan..."
gitleaks detect --source . --verbose --redact

if [ $? -eq 0 ]; then
    echo "No secrets found. Success!"
    exit 0
else
    echo "Secrets detected! Failing the build."
    exit 1
fi
