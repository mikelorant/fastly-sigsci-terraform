resource "fastly_service_vcl" "this" {
  name = "Demo [${terraform.workspace}]"

  domain {
    name    = var.frontend_domain
    comment = "Demo [${terraform.workspace}]"
  }

  backend {
    address           = var.backend_host
    name              = "vcl_service_origin"
    port              = 443
    use_ssl           = true
    ssl_cert_hostname = var.backend_host
    ssl_sni_hostname  = var.backend_host
    override_host     = var.backend_host
  }

  dynamicsnippet {
    name     = "ngwaf_config_init"
    type     = "init"
    priority = 0
  }

  dynamicsnippet {
    name     = "ngwaf_config_miss"
    type     = "miss"
    priority = 9000
  }

  dynamicsnippet {
    name     = "ngwaf_config_pass"
    type     = "pass"
    priority = 9000
  }

  dynamicsnippet {
    name     = "ngwaf_config_deliver"
    type     = "deliver"
    priority = 9000
  }

  dictionary {
    name = var.edge_security_dictionary
  }

  lifecycle {
    ignore_changes = [
      product_enablement,
    ]
  }

  force_destroy = true
}

resource "fastly_service_dictionary_items" "this" {
  for_each = {
    for d in fastly_service_vcl.this.dictionary : d.name => d if d.name == var.edge_security_dictionary
  }

  service_id    = fastly_service_vcl.this.id
  dictionary_id = each.value.dictionary_id
  items = {
    Enabled : "100"
  }
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_init" {
  for_each = {
    for d in fastly_service_vcl.this.dynamicsnippet : d.name => d if d.name == "ngwaf_config_init"
  }

  service_id      = fastly_service_vcl.this.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_init"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_miss" {
  for_each = {
    for d in fastly_service_vcl.this.dynamicsnippet : d.name => d if d.name == "ngwaf_config_miss"
  }

  service_id      = fastly_service_vcl.this.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_miss"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_pass" {
  for_each = {
    for d in fastly_service_vcl.this.dynamicsnippet : d.name => d if d.name == "ngwaf_config_pass"
  }

  service_id      = fastly_service_vcl.this.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_pass"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_deliver" {
  for_each = {
    for d in fastly_service_vcl.this.dynamicsnippet : d.name => d if d.name == "ngwaf_config_deliver"
  }

  service_id      = fastly_service_vcl.this.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_deliver"
  manage_snippets = false
}
