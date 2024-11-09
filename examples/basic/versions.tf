terraform {
  required_version = ">= 1.3"

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
      source  = "argoproj-labs/argocd"
      version = ">= 7"
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
