variable "axonserver_tag" {
  description = "Axonserver Tag: https://hub.docker.com/r/axoniq/axonserver/tags"
  type        = string
  default     = "latest"
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "axonserver"
}

variable "cluster_name" {
  description = "Axon Server cluster name"
  type        = string
  default     = ""
}

variable "nodes_number" {
  description = "number of axonserver nodes"
  type        = number
  default     = 1
}

variable "public_domain" {
  description = "Public domain"
  type        = string
  default     = ""
}

variable "axonserver_license_path" {
  description = "Axon Server license path"
  type        = string
  default     = ""
}

variable "console_authentication" {
  description = "Console Authentication token"
  type        = string
  default     = ""
}

variable "resources_limits_cpu" {
  description = "spec.container.resources.limits.cpu"
  type        = number
  default     = 1
}

variable "resources_limits_memory" {
  description = "spec.container.resources.limits.memory"
  type        = string
  default     = "1Gi"
}

variable "resources_requests_cpu" {
  description = "spec.container.resources.requests.cpu"
  type        = number
  default     = 1
}

variable "resources_requests_memory" {
  description = "spec.container.resources.requests.memory"
  type        = string
  default     = "1Gi"
}

variable "events_storage" {
  description = "Events PVC storage"
  type        = string
  default     = "5Gi"
}

variable "log_storage" {
  description = "Log PVC storage"
  type        = string
  default     = "2Gi"
}

variable "data_storage" {
  description = "Data PVC storage"
  type        = string
  default     = "10Gi"
}

variable "plugins_storage" {
  description = "Plugins PVC storage"
  type        = string
  default     = "1Gi"
}

variable "license_storage" {
  description = "License PVC storage"
  type        = string
  default     = "1Gi"
}

variable "axonserver_properties" {
  description = "Path to axonserver.properties file"
  type        = string
  default     = ""
}

variable "devmode_enabled" {
  description = "Axon Server devmode"
  type        = bool
  default     = false
}

variable "assign_pods_to_different_nodes" {
  description = "Avoid co location of the replicas on the same node"
  type        = bool
  default     = false
}
