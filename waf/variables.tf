variable "site" {
  type        = string
  description = "Site name for NGWAF."
}

variable "fastly_sids" {
  type        = list
  description = "List of Fastly service IDs."
}
