variable "site" {
  type        = string
  description = "Site name for NGWAF."
}

variable "fastly_sid" {
  type        = string
  description = "Fastly service ID."
}

variable "dictionary_name" {
  type        = string
  description = "Fastly edge security dictionary name."
}
