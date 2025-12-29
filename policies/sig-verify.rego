package lib.sigstore

# Policy: Reject images without a valid Sigstore signature
# For demonstration purposes, this is a placeholder that would be integrated with Gatekeeper and Cosign

violation[{"msg": msg}] {
  input.review.kind.kind == "Pod"
  some i
  image := input.review.object.spec.containers[i].image
  not has_valid_signature(image)
  msg := sprintf("Image '%v' does not have a valid Sigstore signature. Deployment rejected.", [image])
}

has_valid_signature(image) {
  # This would normally call an external data source or a sidecar for verification
  # For the demo, we'll assume only images from our 'ironclad' repo are signed
  startswith(image, "ironclad/")
}
