# Terraform Module to Deploy Axon Server on Kubernetes

![Kubernetes](https://img.shields.io/badge/Kubernetes-3069DE?style=for-the-badge&logo=kubernetes&logoColor=white) 
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/AxonIQ/terraform-axonserver-k8s/)
![Release](https://badgen.net/github/release/AxonIQ/terraform-axonserver-k8s/)

---

## Usage

### Single Node Deployment

For a single node deployment, you don't need to provide a license or console authentication:

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.18"
  
  axonserver_tag = "2025.1.5-jdk-17"

  nodes_number  = 1
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
}
```

### Multi-Node Cluster Deployment

For multi-node deployments (clustering), you must provide either a license file or console authentication token:

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.18"
  
  axonserver_tag = "2025.1.5-jdk-17"

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
  
  # Option 1: Provide a license file
  axonserver_license_path = file("${path.module}/axoniq.license")
  
  # Option 2: Or use console authentication (Axon Server Cloud)
  # console_authentication = "your-console-token"
  
  # Optional: Custom properties file
  axonserver_properties = file("${path.module}/axonserver.properties")
}
```

### GKE Network Endpoint Groups (NEGs)

To enable GKE NEGs for direct pod communication:

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.18"
  
  axonserver_tag = "2025.1.5-jdk-17"

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
  
  axonserver_license_path = file("${path.module}/axoniq.license")
  
  # Enable NEGs for GKE
  gke_neg      = true
  gke_neg_zone = ["us-central1-a", "us-central1-b", "us-central1-c"]
}
```

### Advanced Configuration

For advanced scenarios with custom JVM options and access control settings:

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.18"
  
  axonserver_tag = "2025.1.5-jdk-17"

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
  
  axonserver_license_path = file("${path.module}/axoniq.license")
  
  # Custom JVM options
  java_tool_options = "-Xmx2g -Xms2g -XX:+UseG1GC"
  
  # Disable access control (not recommended for production)
  accesscontrol_enabled = false
}
```

### Deploy your own Axon Server image

If you want to deploy another Axon Server docker image, different from the one in `axoniq/axonserver`:

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.18"
  
  axonserver_tag = "2025.1.5-jdk-17"
  axonserver_image = "eu.gcr.io/my-project/axonserver"

  nodes_number  = 1
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_axonserver_tag"></a> [axonserver_tag](#input_axonserver_tag) | [Axon Server Tag](https://hub.docker.com/r/axoniq/axonserver/tags) | `string` | `"latest"` | no |
| <a name="input_namespace"></a> [namespace](#input_namespace) | Kubernetes cluster namespace | `string` | `"axonserver"` | no |
| <a name="input_create_namespace"></a> [create_namespace](#input_create_namespace) | Whether to create the namespace or use an existing one | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name) | Axon Server cluster name | `string` | `""` | yes |
| <a name="input_nodes_number"></a> [nodes_number](#input_nodes_number) | Number of Axon Server nodes to deploy. When > 1, either `console_authentication` or `axonserver_license_path` is required | `number` | `1` | yes |
| <a name="input_public_domain"></a> [public_domain](#input_public_domain) | The domain that is added to the hostname when returning hostnames to client applications | `string` | `""` | yes |
| <a name="input_axonserver_license_path"></a> [axonserver_license_path](#input_axonserver_license_path) | Path to the Axon Server license file. Required for multi-node deployments (nodes_number > 1) unless `console_authentication` is provided | `string` | `""` | conditional |
| <a name="input_console_authentication"></a> [console_authentication](#input_console_authentication) | Console authentication token for Axon Server Cloud. Required for multi-node deployments (nodes_number > 1) unless `axonserver_license_path` is provided | `string` | `""` | conditional |
| <a name="input_axonserver_properties"></a> [axonserver_properties](#input_axonserver_properties) | Custom Axon Server properties file content. If not provided, a default configuration will be generated | `string` | `""` | no |
| <a name="input_java_tool_options"></a> [java_tool_options](#input_java_tool_options) | Java tool options for passing custom JVM options to Axon Server (e.g., heap size, GC settings) | `string` | `""` | no |
| <a name="input_accesscontrol_enabled"></a> [accesscontrol_enabled](#input_accesscontrol_enabled) | Enable Axon Server [access control](https://docs.axoniq.io/axon-server-reference/v2025.1/axon-server/security/access-control-ee/). Recommended to keep enabled in production | `bool` | `true` | no |
| <a name="input_resources_limits_cpu"></a> [resources_limits_cpu](#input_resources_limits_cpu) | CPU resource limits for Axon Server pods | `number` | `1` | no |
| <a name="input_resources_limits_memory"></a> [resources_limits_memory](#input_resources_limits_memory) | Memory resource limits for Axon Server pods | `string` | `"1Gi"` | no |
| <a name="input_resources_requests_cpu"></a> [resources_requests_cpu](#input_resources_requests_cpu) | CPU resource requests for Axon Server pods | `number` | `1` | no |
| <a name="input_resources_requests_memory"></a> [resources_requests_memory](#input_resources_requests_memory) | Memory resource requests for Axon Server pods | `string` | `"1Gi"` | no |
| <a name="input_events_storage"></a> [events_storage](#input_events_storage) | Persistent volume size for event storage | `string` | `"5Gi"` | no |
| <a name="input_log_storage"></a> [log_storage](#input_log_storage) | Persistent volume size for log storage | `string` | `"2Gi"` | no |
| <a name="input_data_storage"></a> [data_storage](#input_data_storage) | Persistent volume size for data storage | `string` | `"10Gi"` | no |
| <a name="input_plugins_storage"></a> [plugins_storage](#input_plugins_storage) | Persistent volume size for plugins storage | `string` | `"1Gi"` | no |
| <a name="input_license_storage"></a> [license_storage](#input_license_storage) | Persistent volume size for license storage (only used with console_authentication) | `string` | `"1Gi"` | no |
| <a name="input_devmode_enabled"></a> [devmode_enabled](#input_devmode_enabled) | Enable Axon Server development mode (disables security features) | `bool` | `false` | no |
| <a name="input_assign_pods_to_different_nodes"></a> [assign_pods_to_different_nodes](#input_assign_pods_to_different_nodes) | Use pod anti-affinity to avoid co-location of replicas on the same Kubernetes node | `bool` | `false` | no |
| <a name="input_gke_neg"></a> [gke_neg](#input_gke_neg) | Enable GKE Network Endpoint Groups (NEGs) for direct pod communication. When enabled, `gke_neg_zone` must be provided | `bool` | `false` | no |
| <a name="input_gke_neg_zone"></a> [gke_neg_zone](#input_gke_neg_zone) | List of GKE zones for NEG configuration. Required when `gke_neg` is true | `list(string)` | `[]` | conditional |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_axonserver_token"></a> [axonserver_token](#output_axonserver_token) | The Axon Server internal token, automatically generated by Terraform |

## Important Notes

### Clustering Requirements

When deploying a multi-node cluster (`nodes_number > 1`), you must provide **one** of the following:
- **`axonserver_license_path`**: Path to your Axon Server Enterprise license file
- **`console_authentication`**: Authentication token for Axon Server Cloud

Single node deployments (`nodes_number = 1`) do not require either of these parameters.

### GKE Network Endpoint Groups

When enabling GKE NEGs (`gke_neg = true`), you must provide at least one zone in `gke_neg_zone`. This feature creates Network Endpoint Groups for direct pod communication, useful for:
- Load balancing directly to pods
- Bypassing kube-proxy
- Improved performance for gRPC connections

### Access Control

Access control is enabled by default (`accesscontrol_enabled = true`). This is the recommended setting for production environments. Only disable access control in development or testing scenarios where security is not a concern.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | >= 2.31.0 |
| <a name="provider_random"></a> [random](#provider_random) | >= 3.6.2 |
| <a name="provider_template"></a> [template](#provider_template) | >= 2.2.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.9.0 |

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## Authors

<a href="https://github.com/AxonIQ/terraform-axonserver-k8s/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AxonIQ/terraform-axonserver-k8s" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
