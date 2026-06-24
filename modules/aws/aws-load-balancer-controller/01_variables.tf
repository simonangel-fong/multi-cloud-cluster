# variables.tf

variable "cluster_name" {
  description = "EKS cluster name (used by the controller to discover subnets/SGs and tag ALB/NLB resources)"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS cluster IAM OIDC provider (IRSA trust)"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS cluster IAM OIDC provider, without scheme (e.g. oidc.eks.<region>.amazonaws.com/id/XXXX)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster runs"
  type        = string
}

variable "aws_region" {
  description = "AWS region the cluster runs in"
  type        = string
}

variable "chart_version" {
  description = "aws-load-balancer-controller Helm chart version"
  type        = string
  default     = "3.4.0"
}

variable "policy_version" {
  description = "Git ref of the upstream IAM policy JSON to fetch from kubernetes-sigs/aws-load-balancer-controller (tag or branch)"
  type        = string
  default     = "v3.4.0"
}

variable "namespace" {
  description = "Namespace the controller is installed into"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account name used by the controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "extra_values" {
  description = "Additional Helm values YAML merged on top of module defaults"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to IAM resources created by this module"
  type        = map(string)
  default     = {}
}
