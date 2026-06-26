# variables.tf

# ##############################
# Project Metadata
# ##############################
variable "project_name" {
  type    = string
  default = "multi-cloud-k8s"
}

# ##############################
# Environemnt
# ##############################
variable "env" {
  type = string
}

# ##############################
# Cloudflare
# ##############################
variable "cf_zone_name" {
  type = string
}
variable "cf_api_token" {
  type      = string
  sensitive = true
}
variable "cf_account_id" {
  type = string
}

# ##############################
# App
# ##############################
variable "hostname" {
  type    = string
  default = "cloud"
}
