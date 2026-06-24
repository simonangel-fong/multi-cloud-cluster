# main.tf

# ##############################
# IAM policy (fetched from upstream)
# ##############################
data "http" "iam_policy" {
  url = local.policy_url

  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-${local.name}"
  description = "Permissions for the AWS Load Balancer Controller on EKS cluster ${var.cluster_name}"
  policy      = data.http.iam_policy.response_body

  tags = merge(
    var.tags,
    { Name = "${var.cluster_name}-${local.name}" }
  )
}

# ##############################
# IRSA role
# ##############################
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-${local.name}"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = merge(
    var.tags,
    { Name = "${var.cluster_name}-${local.name}" }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

# ##############################
# Helm release
# ##############################
resource "helm_release" "this" {
  name       = local.name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version
  namespace  = var.namespace

  values = compact([
    local.default_values,
    var.extra_values,
  ])

  atomic        = false
  wait          = false
  wait_for_jobs = false
  timeout       = 600

  depends_on = [aws_iam_role_policy_attachment.this]
}
