# outputs.tf

output "release_name" { value = helm_release.cilium.name }
output "release_namespace" { value = helm_release.cilium.namespace }
output "cilium_version" { value = helm_release.cilium.version }
