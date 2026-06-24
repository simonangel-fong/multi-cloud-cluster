# variable.tf
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the EKS control plane ENIs will be placed (at least two AZs)"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS public API endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS private API endpoint is enabled"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint when enabled"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_tags" {
  description = "Tags applied to all EKS resources"
  type        = map(string)
  default     = {}
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to send to CloudWatch Logs. Valid values: api, audit, authenticator, controllerManager, scheduler."
  type        = list(string)
  default     = ["api", "audit"]
}