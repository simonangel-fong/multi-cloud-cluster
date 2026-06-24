# variables.tf

variable "argocd_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "9.7.0"
}

variable "namespace" {
  description = "Namespace Argo CD is installed into"
  type        = string
  default     = "argocd"
}

variable "extra_values" {
  description = "Additional Helm values YAML merged on top of module defaults"
  type        = string
  default     = ""
}
