resource "sigsci_site" "this" {
  short_name             = var.site
  display_name           = var.site
  block_duration_seconds = 86400
  block_http_code        = 406
  agent_anon_mode        = ""
  agent_level            = "block"
}

resource "sigsci_edge_deployment" "this" {
  site_short_name = var.site
  provisioner "local-exec" {
    command = "echo 'Sleep for 120 seconds'; sleep 120"
  }
  depends_on = [
    sigsci_site.this
  ]
}
