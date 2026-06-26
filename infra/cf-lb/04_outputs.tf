# outputs.tf

# ##############################
# Cloudflare
# ##############################
output "cf_zone_name" {
  description = "Cloudflare zone name"
  value       = data.cloudflare_zone.zone.name
}

output "cf_monitor_id" {
  description = "Cloudflare LB monitor id"
  value       = cloudflare_load_balancer_monitor.http.id
}
