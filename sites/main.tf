resource "sigsci_site" "this" {
  for_each = toset(var.sites)

  short_name             = each.key
  display_name           = each.key
  block_duration_seconds = 86400
  block_http_code        = 406
  agent_anon_mode        = ""
  agent_level            = "block"
}

resource "sigsci_edge_deployment" "this" {
  for_each = toset(var.sites)

  site_short_name = each.key
  provisioner "local-exec" {
    command = "echo 'Sleep for 120 seconds'; sleep 120"
  }
  depends_on = [
    sigsci_site.this
  ]
}
