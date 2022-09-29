locals {
  linkerd_enabled   = module.this.enabled && contains(local.argocd_helm_apps_enabled, "linkerd")
  linkerd_certs     = local.linkerd_enabled ? toset(["webhook.${local.linkerd_namepsace}.cluster.local", "root.${local.linkerd_namepsace}.cluster.local"]) : toset([])
  linkerd_namepsace = local.linkerd_enabled ? one(kubernetes_namespace.linkerd[*].metadata[0].name) : ""
}

resource "tls_private_key" "linkerd" {
  for_each = local.linkerd_certs

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd" {
  for_each = local.linkerd_certs

  private_key_pem       = tls_private_key.linkerd[each.key].private_key_pem
  validity_period_hours = 87600
  early_renewal_hours   = 80000
  is_ca_certificate     = true

  subject {
    common_name = each.value
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_namespace" "linkerd" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    annotations = {
      name                = try(local.argocd_helm_apps_set["linkerd"]["namespace"], "")
      "linkerd.io/inject" = "disabled"
    }

    labels = {
      "linkerd.io/is-control-plane"          = "true"
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/control-plane-ns"          = try(local.argocd_helm_apps_set["linkerd"]["namespace"], "")
    }

    name = try(local.argocd_helm_apps_set["linkerd"]["namespace"], "")
  }
}

resource "kubernetes_secret" "linkerd" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name      = "linkerd-trust-anchor"
    namespace = local.linkerd_namepsace
  }

  data = {
    "tls.crt" = try(tls_self_signed_cert.linkerd["root.${local.linkerd_namepsace}.cluster.local"].cert_pem, "")
    "tls.key" = try(tls_private_key.linkerd["root.${local.linkerd_namepsace}.cluster.local"].private_key_pem, "")
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "linkerd_webhook" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name      = "webhook-issuer-tls"
    namespace = local.linkerd_namepsace
  }

  data = {
    "tls.crt" = try(tls_self_signed_cert.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].cert_pem, "")
    "tls.key" = try(tls_private_key.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].private_key_pem, "")
  }

  type = "kubernetes.io/tls"
}
