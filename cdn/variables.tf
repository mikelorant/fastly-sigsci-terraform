variable "frontend_domain" {
  type        = string
  description = "domain for your service. Try 'YOURNAME.global.ssl.fastly.net' to get up and running quickly."
}

variable "backend_host" {
  type        = string
  description = "hostname used for backend."
}

variable "configure_waf" {
  type        = bool
  description = "Enable NGWAF."
}

variable "edge_security_dictionary" {
  type    = string
  default = "Edge_Security"
}

variable "site" {
  type        = string
  description = "Site name for NGWAF."
}
