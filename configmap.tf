locals {
  axonserver_properties = var.axonserver_properties == "" ? data.template_file.axonserver_properties.rendered : var.axonserver_properties
}

data "template_file" "axonserver_properties" {
  template = file("${path.module}/conf/axonserver.properties.tftpl")

  vars = {
    first_name             = "${var.cluster_name}-1"
    public_domain          = var.public_domain
    namespace              = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
    internal_token         = random_uuid.internal_token.result
    devmode_enabled        = var.devmode_enabled
    console_authentication = var.console_authentication
    accesscontrol_enabled  = var.accesscontrol_enabled
  }
}

resource "kubernetes_config_map" "axonserver_properties" {
  metadata {
    name      = "axonserver.properties"
    namespace = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
  }

  data = {
    "axonserver.properties" = local.axonserver_properties
  }
}
