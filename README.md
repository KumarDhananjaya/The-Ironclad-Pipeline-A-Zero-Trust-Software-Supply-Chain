# The Ironclad Pipeline: A Zero-Trust Software Supply Chain

This project implements an Enterprise-grade DevSecOps platform focused on **Software Supply Chain Security** and **Continuous Compliance**. 

## 🛡️ Architecture Overview
The pipeline ensures that only scanned, verified, and signed code reaches production.

1. **Secure IaC**: Cluster provisioned with Kind.
2. **Shift-Left CI**: 
   - **Secret Scanning**: Gitleaks prevents hardcoded credentials.
   - **SCA/Container Scanning**: Trivy identifies vulnerabilities in images.
   - **SAST**: SonarQube analyzes code quality.
3. **Policy as Code**: OPA Gatekeeper enforces image signature verification before deployment.
4. **Runtime Security**: Falco monitors for suspicious activity (e.g., shell execution inside containers).
5. **Secret Management**: HashiCorp Vault manages sensitive data dynamically.

## 🚀 Key Features

### 1. Zero-Trust Admission Control
Using **OPA Gatekeeper**, the cluster rejects any deployment that does not meet our security standards.
- **Verification**: Try deploying `nginx`. OPA will block it because it lacks our pipeline's signature.

### 2. Runtime Threat Detection
**Falco** is active on the cluster. If an attacker (or developer) attempts to spawn a shell in a production container, an alert is triggered immediately.

### 3. Dynamic Secrets
The application fetches its `AWS_SECRET` (and others) from **HashiCorp Vault**, eliminating the need for insecure `.env` files or hardcoded strings.

## 📈 Verification Gallery

### OPA Blocking Unsigned Image
![OPA Rejection](file:///d:/Projects/POC/The-Ironclad-Pipeline-A-Zero-Trust-Software-Supply-Chain/docs/screenshots/opa-rejection.png)
> *Proof of OPA Gatekeeper blocking an unsigned nginx image.*

### Falco Runtime Alert
![Falco Alert](file:///d:/Projects/POC/The-Ironclad-Pipeline-A-Zero-Trust-Software-Supply-Chain/docs/screenshots/falco-alert.png)
> *Log output showing Falco detecting a shell spawn inside the ironclad-app container.*

## 🔧 Setup
1. `kind create cluster --config infrastructure/terraform/kind-config.yaml`
2. `helm install` local charts for Vault, Gatekeeper, and Falco.
3. `kubectl apply -f policies/` to enforce security rules.