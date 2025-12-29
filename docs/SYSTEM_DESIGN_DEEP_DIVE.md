# System Design Deep Dive: Zero-Trust Software Supply Chain

## 1. The Problem: The "Swiss Cheese" Pipeline
Traditionally, security is a checkbox at the end of a build.
- **Flaw 1**: Secrets leaked in Git.
- **Flaw 2**: Vulnerable base images (Node/Python) used without checking.
- **Flaw 3**: Tampering in the Container Registry.
- **Flaw 4**: No enforcement on what gets deployed.

## 2. The Solution: The "Ironclad" Defense-in-Depth

### 2.1 Identity & Access (Vault)
We move away from "Static Secrets" to "Dynamic Identities".
- **Mechanism**: The application pod logs into Vault using its K8s ServiceAccount Token. Vault verifies this with the K8s API server.
- **Benefit**: No secrets are ever stored in the repo; they exist only in memory during runtime.

### 2.2 Integrity & Provenance (Sigstore/Cosign)
How do we know the image in K8s is the same one Jenkins built?
- **Workflow**:
    1. Jenkins builds image.
    2. Scans pass.
    3. Cosign generates a signature.
    4. Signature is pushed to the registry alongside the image.
- **Impact**: It creates a "Chain of Custody" for your software.

### 2.3 Governance & Policy (OPA Gatekeeper)
"Policy as Code" (PaC) allows us to treat security rules like software.
- **ConstraintTemplate**: The engine (Rego).
- **Constraint**: The specific rule (e.g., "Only images from `ironclad/` repo").
- **Benefit**: Uniform enforcement across multiple clusters without manual checks.

### 2.4 Observability & Threat Detection (Falco)
The "Security Guard" inside the cluster.
- **How it works**: Uses a kernel module or eBPF probe to intercept every system call.
- **Detection**: It knows when a process is `exec`'d, when a file is opened, or when a network connection is made.
- **Rule Example**: Alert if `cat /etc/shadow` is run by a user other than `root` in a specific namespace.

## 3. Scalability Considerations
- **Centralized Dashboard (DefectDojo)**: In a real-world scenario, we wouldn't look at individual logs. DefectDojo aggregates Trivy, Sonar, and Gitleaks results into a single risk score.
- **Automated Remediation**: In advanced setups, a Falco alert could trigger a Lambda function to isolate the compromised node or kill the container automatically.

## 4. Conclusion
"The Ironclad Pipeline" isn't just a set of tools; it's a **Governance Framework**. It transforms security from a manual bottleneck into a frictionless, automated guardrail.
