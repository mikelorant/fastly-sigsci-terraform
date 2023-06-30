variable "frontend_domain" {
  type        = string
  description = "domain for your service. Try 'YOURNAME.global.ssl.fastly.net' to get up and running quickly."
}

variable "backend_host" {
  type        = string
  description = "hostname used for backend."
}

variable "edge_security_dictionary" {
  type    = string
  default = "Edge_Security"
}
