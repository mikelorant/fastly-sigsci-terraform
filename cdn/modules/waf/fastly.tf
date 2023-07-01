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

// resource "fastly_service_dynamic_snippet_content" "ngwaf_config_init" {
//   service_id      = var.fastly_sid
//   snippet_id      = var.snippets["ngwaf_config_init"]
//   content         = "### Fastly managed ngwaf_config_init"
//   manage_snippets = false
// }
//
// resource "fastly_service_dynamic_snippet_content" "ngwaf_config_miss" {
//   service_id      = var.fastly_sid
//   snippet_id      = var.snippets["ngwaf_config_miss"]
//   content         = "### Fastly managed ngwaf_config_miss"
//   manage_snippets = false
// }
//
// resource "fastly_service_dynamic_snippet_content" "ngwaf_config_pass" {
//   service_id      = var.fastly_sid
//   snippet_id      = var.snippets["ngwaf_config_pass"]
//   content         = "### Fastly managed ngwaf_config_pass"
//   manage_snippets = false
// }
//
// resource "fastly_service_dynamic_snippet_content" "ngwaf_config_deliver" {
//   service_id      = var.fastly_sid
//   snippet_id      = var.snippets["ngwaf_config_deliver"]
//   content         = "### Fastly managed ngwaf_config_deliver"
//   manage_snippets = false
// }
