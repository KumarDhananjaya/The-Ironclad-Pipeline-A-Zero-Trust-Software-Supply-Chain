# Interview Prep Guide: The Ironclad Pipeline

## 1. Project Pitch (The "Elevator Statement")
"I built **The Ironclad Pipeline**, a Zero-Trust Software Supply Chain platform. It goes beyond simple CI/CD by ensuring every component—from infrastructure code to the running container—is secured, verified, and monitored. I integrated OPA for policy enforcement, HashiCorp Vault for secret management, and Falco for runtime security, effectively creating a self-defending software factory."

## 2. Top 5 "Killer" Interview Questions

### Q1: Why did you choose OPA Gatekeeper instead of just checking signatures in Jenkins?
**Answer**: "Checking signatures in Jenkins is a 'Shift-Left' practice, but it's not enough for Zero-Trust. A hacker could bypass Jenkins and deploy a malicious image directly to the cluster via `kubectl`. By using OPA Gatekeeper as an **Admission Controller**, we enforce security at the cluster entry point. It doesn't matter *how* an image tries to get in; if it's not signed, the cluster itself says 'No'."

### Q2: How does Falco differ from traditional logging?
**Answer**: "Traditional logs tell you what happened *after* the fact. Falco is a **Runtime Security** tool that uses eBPF to monitor syscalls in real-time. It can detect a container reaching out to a suspicious IP or a shell being spawned the second it happens, allowing for immediate automated response (like killing the pod)."

### Q3: What happens if HashiCorp Vault goes down?
**Answer**: "This is a critical availability question. In a production environment, Vault would be deployed in a **Highly Available (HA)** mode with a Raft backend across multiple availability zones. For the application, we use 'Secret Caching' or 'Sidecar' patterns so the app can continue to function for a short grace period while Vault recovers, ensuring security doesn't break production."

### Q4: How do you handle 'Security Fatigue' or 'False Positives' in scans?
**Answer**: "I implemented **Vulnerability Management** logic. We don't just fail a build on any finding; we fail on 'Critical' or 'High' vulnerabilities with known fixes. We also use SonarQube Quality Gates to ensure that we are managing 'Technical Debt' and security risks incrementally rather than overwhelming developers."

### Q5: What is 'Supply Chain Security' in this context?
**Answer**: "It's about the **Integrity** of the artifact. By signing the image with Cosign after the scans pass, we create a cryptographic link. This proves that the image running in production is exactly the same one that passed our security tests, and hasn't been tampered with or replaced in the registry."

## 3. Technical Deep-Dive Checklist
- [ ] **eBPF**: Be ready to explain how Falco uses it (kernel-level observability).
- [ ] **Rego**: Understand the syntax—it's declarative and based on Datalog.
- [ ] **Kube-bench**: Know that it checks against CIS (Center for Internet Security) benchmarks.
- [ ] **Sigstore**: Explain that it's an open-standard for signing and verifying artifacts.
