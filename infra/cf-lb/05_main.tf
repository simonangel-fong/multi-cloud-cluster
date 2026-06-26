# main.tf

# ##############################
# Zone lookup
# ##############################
data "cloudflare_zone" "zone" {
  filter = {
    name = var.cf_zone_name
  }
}

# ##############################
# Health monitor
# ##############################
resource "cloudflare_load_balancer_monitor" "http" {
  account_id       = var.cf_account_id
  type             = "http"
  description      = "${local.common_name} HTTP monitor for ${local.fqdn}"
  method           = "GET"
  path             = "/api/"
  port             = 80
  expected_codes   = "200"
  follow_redirects = false
  allow_insecure   = false
  interval         = 60
  retries          = 2
  timeout          = 5

  header = {
    Host = [local.fqdn]
  }
}
