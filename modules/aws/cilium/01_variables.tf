# variables.tf

variable "cluster_endpoint" {
  description = "EKS cluster API endpoint (used by Cilium kube-proxy replacement)"
  type        = string
}

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
  default     = "1.19.5"
}

variable "namespace" {
  description = "Namespace Cilium is installed into"
  type        = string
  default     = "kube-system"
}

variable "pod_cidr" {
  description = "Pod CIDR for Cilium IPAM (overlay mode). Should not overlap the VPC CIDR."
  type        = string
  default     = "10.244.0.0/16"
}

variable "extra_values" {
  description = "Additional Helm values YAML merged on top of module defaults"
  type        = string
  default     = ""
}
