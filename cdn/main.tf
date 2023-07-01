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

  // NGWAF start

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

  // NGWAF end

  lifecycle {
    ignore_changes = [
      product_enablement,
    ]
  }

  force_destroy = true
}

// NGWAF start

// locals {
//   fastly_snippets = {
//     for snippet in fastly_service_vcl.this.dynamicsnippet : snippet.name => snippet.snippet_id
//   }
// }

module "waf" {
  source = "./modules/waf"

  site            = var.site
  fastly_sid      = fastly_service_vcl.this.id
  dictionary_name = var.edge_security_dictionary
  // snippets        = local.fastly_snippets

  depends_on = [
    fastly_service_vcl.this
  ]
}

// NGWAF end
