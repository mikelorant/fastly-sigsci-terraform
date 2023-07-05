locals {
  ngwaf_dynamicsnippet = {
    "init"    = 0
    "miss"    = 9000
    "pass"    = 9000
    "deliver" = 9000
  }
}

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

  dynamic "dynamicsnippet" {
    for_each = var.configure_waf ? local.ngwaf_dynamicsnippet : {}

    content {
      name     = "ngwaf_config_${dynamicsnippet.key}"
      type     = dynamicsnippet.key
      priority = dynamicsnippet.value
    }
  }

  dynamic "dictionary" {
    for_each = var.configure_waf ? [1] : []

    content {
      name = var.edge_security_dictionary
    }
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

module "waf" {
  source = "./modules/waf"

  site            = var.site
  fastly_sid      = fastly_service_vcl.this.id
  dictionary_name = var.edge_security_dictionary

  depends_on = [
    fastly_service_vcl.this
  ]
}

// NGWAF end
