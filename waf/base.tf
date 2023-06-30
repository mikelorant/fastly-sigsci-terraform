terraform {
  required_version = "~> 1.4.6"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "~> 5.2.1"
    }
    sigsci = {
      source  = "signalsciences/sigsci"
      version = "~> 1.2.30"
    }
  }
}
