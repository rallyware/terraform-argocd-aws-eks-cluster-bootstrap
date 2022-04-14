terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 1.2"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.14.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
}
