# Low-Level Design (LLD): The Ironclad Pipeline

## 1. Infrastructure Layer (IaC)

### 1.1 Local Cluster (Kind)
The environment uses **Kind** (Kubernetes in Docker) to provision a multi-node cluster.
- **Config**: `infrastructure/terraform/kind-config.yaml`
- **Networking**: Maps ports 80 and 443 to the host for Ingress access.

### 1.2 Configuration Management (Ansible)
- **Hardening**: `infrastructure/ansible/hardening.yml` sets sysctl parameters (IP forwarding, redirect settings) and configures UFW to restrict API server access.

## 2. Secrets Management (HashiCorp Vault)

### 2.1 Deployment
Deployed via Helm chart in `dev` mode for demonstration.
- **Path**: `infrastructure/vault/setup.sh`
- **Integration**: Kubernetes Auth Method enables pods to authenticate with Vault using their existing tokens.

## 3. CI/CD Pipeline (Jenkins/GHA)

### 3.1 Scanning Stages
1. **Secret Scan**: `gitleaks detect --source . --no-git`
2. **Container Scan**: `trivy image --severity CRITICAL <image>`
3. **Signing**: `cosign sign --key <vault-path> <image>` (Simulated in manual flow).

### 3.2 Automation logic
The `Jenkinsfile` orchestrates the flow. If any security check (Gitleaks/Trivy) fails, the `pipeline` terminates, preventing the image from being pushed.

## 4. Policy Enforcement (OPA Gatekeeper)

### 4.1 ConstraintTemplate
Defines the Rego logic:
```rego
package k8scheckimagesignature
violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  not startswith(container.image, "ironclad/")
  msg := sprintf("Image '%v' is not trusted.", [container.image])
}
```

### 4.2 Constraint
Applies the template to all `Pod` resources in the cluster.

## 5. Runtime Security (Falco)

### 5.1 DaemonSet Deployment
Falco runs on every node, tapping into the syscall stream via **eBPF**.
- **Rule**: terminal_shell_in_container
- **Condition**: `proc.name = bash` or `proc.name = sh` in a non-setup context.
