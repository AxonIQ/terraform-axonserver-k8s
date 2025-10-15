resource "kubernetes_service" "axonserver" {
  count = var.nodes_number

  metadata {
    name      = "${var.cluster_name}-${count.index + 1}"
    namespace = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
    labels = {
      app     = "${var.cluster_name}-${count.index + 1}"
      run     = "${var.cluster_name}-${count.index + 1}"
      cluster = var.cluster_name
    }
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "8081"
      "prometheus.io/path"   = "/actuator/prometheus"
    }
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
