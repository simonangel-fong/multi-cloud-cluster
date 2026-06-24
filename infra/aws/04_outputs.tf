# outputs.tf

# # ##############################
# # VPC
# # ##############################
# output "vpc_id" { value = module.vpc.vpc_id }
# output "private_subnet_ids" { value = module.vpc.private_subnet_ids }
# output "public_subnet_ids" { value = module.vpc.public_subnet_ids }

# # ##############################
# # EKS
# # ##############################
# output "cluster_name" { value = module.eks.cluster_name }
# output "cluster_endpoint" { value = module.eks.cluster_endpoint }
# output "cluster_certificate_authority_data" {
#   value     = module.eks.cluster_certificate_authority_data
#   sensitive = true
# }
# output "cluster_security_group_id" { value = module.eks.cluster_security_group_id }
# output "oidc_provider_arn" { value = module.eks.oidc_provider_arn }

# ##############################
# kubeconfig helper
# ##############################
output "kubeconfig_command" {
  description = "Run this to update your local kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
