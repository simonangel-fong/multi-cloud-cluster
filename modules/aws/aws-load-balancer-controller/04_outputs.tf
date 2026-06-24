# outputs.tf

output "release_name" { value = helm_release.this.name }
output "release_namespace" { value = helm_release.this.namespace }
output "chart_version" { value = helm_release.this.version }
output "iam_role_arn" { value = aws_iam_role.this.arn }
output "iam_role_name" { value = aws_iam_role.this.name }
output "service_account_name" { value = var.service_account_name }
