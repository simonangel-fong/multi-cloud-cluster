# main.tf

# ##############################
# Cilium
# ##############################
resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = var.cilium_version
  namespace  = var.namespace

  values = compact([
    local.default_values,
    var.extra_values,
  ])

  atomic        = false
  wait          = false
  wait_for_jobs = false
  timeout       = 600
}
