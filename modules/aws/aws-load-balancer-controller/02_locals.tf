# locals.tf

locals {
  name = "aws-load-balancer-controller"

  oidc_host = replace(var.oidc_provider_url, "https://", "")

  policy_url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.policy_version}/docs/install/iam_policy.json"

  default_values = yamlencode({
    clusterName = var.cluster_name
    region      = var.aws_region
    vpcId       = var.vpc_id

    serviceAccount = {
      create = true
      name   = var.service_account_name
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
      }
    }
  })
}
