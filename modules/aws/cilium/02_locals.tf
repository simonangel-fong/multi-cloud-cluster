# locals.tf

locals {
  k8s_service_host = replace(var.cluster_endpoint, "https://", "")

  # helm values
  default_values = yamlencode({
    kubeProxyReplacement = "true"
    k8sServiceHost       = local.k8s_service_host
    k8sServicePort       = 443

    ipam = {
      mode = "cluster-pool"
      operator = {
        clusterPoolIPv4PodCIDRList = [var.pod_cidr]
        clusterPoolIPv4MaskSize    = 24
      }
    }

    routingMode    = "tunnel"
    tunnelProtocol = "vxlan"

    hubble = {
      enabled = true
      relay   = { enabled = true }
      ui      = { enabled = true }
    }

    operator = {
      replicas = 1
    }
  })
}
