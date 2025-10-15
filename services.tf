resource "kubernetes_service" "axonserver" {
  count = var.nodes_number

  lifecycle {
    precondition {
      condition     = !var.gke_neg || length(var.gke_neg_zone) > 0
      error_message = "When gke_neg is enabled, gke_neg_zone must contain at least one zone. Please provide a list of zones or set gke_neg to false."
    }
  }

  metadata {
    name      = "${var.cluster_name}-${count.index + 1}"
    namespace = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
    labels = {
      app     = "${var.cluster_name}-${count.index + 1}"
      run     = "${var.cluster_name}-${count.index + 1}"
      cluster = var.cluster_name
    }

    annotations = merge(
      {
        "prometheus.io/scrape" = "true"
        "prometheus.io/port"   = "8081"
        "prometheus.io/path"   = "/actuator/prometheus"
      },
      var.gke_neg && length(var.gke_neg_zone) > 0 ? {
        "cloud.google.com/neg"        = "{\"exposed_ports\": {\"8024\":{\"name\": \"k8s-${var.cluster_name}-${count.index + 1}-8024\"}}}"
        "cloud.google.com/neg-status" = "{\"network_endpoint_groups\":{\"8024\":\"k8s-${var.cluster_name}-${count.index + 1}-8024\"},\"zones\":${jsonencode(var.gke_neg_zone)}}"
      } : {}
    )
  }
  spec {
    selector = {
      app     = "${var.cluster_name}-${count.index + 1}"
      run     = "${var.cluster_name}-${count.index + 1}"
      cluster = var.cluster_name
    }
    port {
      name        = "axonserver"
      protocol    = "TCP"
      port        = 8024
      target_port = 8024
    }
    port {
      name        = "client-grpc"
      protocol    = "TCP"
      port        = 8124
      target_port = 8124
    }
    port {
      name        = "internal-grpc"
      protocol    = "TCP"
      port        = 8224
      target_port = 8224
    }
    cluster_ip = "None"
  }
}
