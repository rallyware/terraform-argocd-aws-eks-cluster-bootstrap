locals {
  linkerd_enabled = module.this.enabled && contains(local.argocd_helm_apps_enabled, "linkerd")
  linkerd_certs   = local.linkerd_enabled ? toset(["webhook.linkerd.cluster.local", "root.linkerd.cluster.local"]) : toset([])
}

resource "tls_private_key" "linkerd" {
  for_each = local.linkerd_certs

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd" {
  for_each = local.linkerd_certs

  key_algorithm         = tls_private_key.linkerd[each.key].algorithm
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
