locals {
  linkerd_jaeger_enabled   = module.this.enabled && contains(local.argocd_helm_apps_enabled, "linkerd-jaeger")
  linkerd_jaeger_namepsace = local.linkerd_jaeger_enabled ? one(kubernetes_namespace.linkerd_jaeger[*].metadata[0].name) : ""
}

resource "kubernetes_namespace" "linkerd_jaeger" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  metadata {
    labels = {
      "linkerd.io/extension" = "jaeger"
    }

    annotations = {
      name = try(local.argocd_helm_apps_set["linkerd-jaeger"]["namespace"], "")
    }

    name = try(local.argocd_helm_apps_set["linkerd-jaeger"]["namespace"], "")
  }
}

resource "kubernetes_secret" "linkerd_jaeger_webhook" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  metadata {
    name      = "webhook-issuer-tls"
    namespace = local.linkerd_jaeger_namepsace
  }

  data = {
    "tls.crt" = try(tls_self_signed_cert.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].cert_pem, "")
    "tls.key" = try(tls_private_key.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].private_key_pem, "")
  }

  type = "kubernetes.io/tls"
}
