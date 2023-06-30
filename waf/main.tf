data "fastly_services" "this" {}

locals {
  fastly_service_versions = {
    for service in data.fastly_services.this.details : service.id => service.version
  }
}

resource "sigsci_site" "this" {
  short_name             = var.site
  display_name           = var.site
  block_duration_seconds = 86400
  agent_anon_mode        = ""
  agent_level            = "block"
}

resource "sigsci_edge_deployment" "this" {
  site_short_name = sigsci_site.this.short_name
  provisioner "local-exec" {
    command = "echo 'Sleep for 60 seconds'; sleep 60"
  }
  depends_on = [
    sigsci_site.this
  ]
}

# Requires -parallelism=1
resource "sigsci_edge_deployment_service" "this" {
  for_each = toset(var.fastly_sids)

  site_short_name  = sigsci_site.this.short_name
  fastly_sid       = each.key
  activate_version = true
  percent_enabled  = 100
  depends_on = [
    sigsci_edge_deployment.this
  ]
}

resource "sigsci_edge_deployment_service_backend" "this" {
  for_each = sigsci_edge_deployment_service.this

  site_short_name                   = sigsci_site.this.short_name
  fastly_sid                        = each.key
  fastly_service_vcl_active_version = local.fastly_service_versions[each.key]
  depends_on = [
    sigsci_edge_deployment_service.this,
  ]
}
