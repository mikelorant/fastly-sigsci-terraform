data "fastly_services" "this" {}

data "fastly_dictionaries" "this" {
  service_id      = var.fastly_sid
  service_version = local.fastly_service_versions[var.fastly_sid]
}

locals {
  fastly_service_versions = {
    for service in data.fastly_services.this.details : service.id => service.version
  }
  fastly_dictionaries = {
    for dictionary in data.fastly_dictionaries.this.dictionaries : dictionary.name => dictionary.id
  }
}

resource "fastly_service_dictionary_items" "this" {
  service_id    = var.fastly_sid
  dictionary_id = local.fastly_dictionaries[var.dictionary_name]
  items = {
    Enabled : "100"
  }
}

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
