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
      source  = "oboukili/argocd"
      version = ">= 6"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.14.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2"
    }
  }
}
