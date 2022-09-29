locals {
  linkerd_viz_enabled   = module.this.enabled && contains(local.argocd_helm_apps_enabled, "linkerd-viz")
  linkerd_viz_namepsace = local.linkerd_viz_enabled ? one(kubernetes_namespace.linkerd_viz[*].metadata[0].name) : ""
}

resource "kubernetes_namespace" "linkerd_viz" {
  count = local.linkerd_viz_enabled ? 1 : 0

  metadata {
    labels = {
      "linkerd.io/extension" = "viz"
    }

    annotations = {
      name                = try(local.argocd_helm_apps_set["linkerd-viz"]["namespace"], "")
      "linkerd.io/inject" = "enabled"
    }

    name = try(local.argocd_helm_apps_set["linkerd-viz"]["namespace"], "")

  }
}

resource "kubernetes_secret" "linkerd_viz_webhook" {
  count = local.linkerd_viz_enabled ? 1 : 0

  metadata {
    name      = "webhook-issuer-tls"
    namespace = local.linkerd_viz_namepsace
  }

  data = {
    "tls.crt" = try(tls_self_signed_cert.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].cert_pem, "")
    "tls.key" = try(tls_private_key.linkerd["webhook.${local.linkerd_namepsace}.cluster.local"].private_key_pem, "")
  }

  type = "kubernetes.io/tls"
}
