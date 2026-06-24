# variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster this node group joins"
  type        = string
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "default"
}

variable "subnet_ids" {
  description = "Subnet IDs where worker nodes will run (typically private subnets)"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "ami_type" {
  description = "AMI type. Common: AL2023_x86_64_STANDARD, AL2023_ARM_64_STANDARD, BOTTLEROCKET_x86_64."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "disk_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 20
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 10
}

variable "max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during rolling updates"
  type        = number
  default     = 33
}

variable "labels" {
  description = "Kubernetes labels applied to nodes"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "Kubernetes taints applied to nodes"
  type = map(object({
    value  = optional(string)
    effect = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
