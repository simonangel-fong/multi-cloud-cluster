# outputs.tf

output "node_group_arn" { value = aws_eks_node_group.this.arn }
output "node_group_status" { value = aws_eks_node_group.this.status }
output "node_iam_role_arn" { value = aws_iam_role.node.arn }
output "node_iam_role_name" { value = aws_iam_role.node.name }
