resource "sigsci_edge_deployment_service" "this" {
  site_short_name  = var.site
  fastly_sid       = var.fastly_sid
  activate_version = true
  percent_enabled  = 100
}

resource "sigsci_edge_deployment_service_backend" "this" {
  site_short_name                   = var.site
  fastly_sid                        = var.fastly_sid
  fastly_service_vcl_active_version = local.fastly_service_versions[var.fastly_sid]
  depends_on = [
    sigsci_edge_deployment_service.this
  ]
}
