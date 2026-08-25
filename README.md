## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 5.2.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aad_rbac"></a> [aad\_rbac](#input\_aad\_rbac) | Azure AD RBAC settings, used only when aad\_rbac\_enabled = true. | <pre>object({<br/>    tenant_id              = optional(string)<br/>    admin_group_object_ids = optional(list(string))<br/>    azure_rbac_enabled     = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_aad_rbac_enabled"></a> [aad\_rbac\_enabled](#input\_aad\_rbac\_enabled) | Enable Azure AD (Entra ID) integration for Kubernetes RBAC. Default true. | `bool` | `true` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | Enable the Azure Policy add-on. Default true. | `bool` | `true` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Configuration for the system (default) node pool. Required by AKS. | <pre>object({<br/>    name                         = string<br/>    vm_size                      = string<br/>    node_count                   = optional(number, 2)<br/>    auto_scaling_enabled         = optional(bool, false)<br/>    min_count                    = optional(number)<br/>    max_count                    = optional(number)<br/>    max_pods                     = optional(number)<br/>    os_disk_size_gb              = optional(number)<br/>    os_sku                       = optional(string)<br/>    vnet_subnet_id               = optional(string)<br/>    zones                        = optional(list(string))<br/>    node_labels                  = optional(map(string))<br/>    only_critical_addons_enabled = optional(bool, false)<br/>    orchestrator_version         = optional(string)<br/>    type                         = optional(string, "VirtualMachineScaleSets")<br/>    # Required by AKS when the node pool needs to be rotated in place.<br/>    temporary_name_for_rotation = optional(string, "tmpdefault")<br/>  })</pre> | n/a | yes |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix for a public cluster. Set this OR dns\_prefix\_private\_cluster, not both. | `string` | `null` | no |
| <a name="input_dns_prefix_private_cluster"></a> [dns\_prefix\_private\_cluster](#input\_dns\_prefix\_private\_cluster) | DNS prefix for a private cluster. Set this OR dns\_prefix, not both. | `string` | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Managed identity block. Use this OR service\_principal. type = SystemAssigned \| UserAssigned. | <pre>object({<br/>    type         = optional(string, "SystemAssigned")<br/>    identity_ids = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| <a name="input_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#input\_key\_vault\_secrets\_provider) | Key Vault Secrets Provider settings, used only when key\_vault\_secrets\_provider\_enabled = true. | <pre>object({<br/>    secret_rotation_enabled  = optional(bool, true)<br/>    secret_rotation_interval = optional(string, "2m")<br/>  })</pre> | `{}` | no |
| <a name="input_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#input\_key\_vault\_secrets\_provider\_enabled) | Enable the Azure Key Vault Secrets Provider (CSI) add-on. Default true. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes control-plane version. Defaults to a pinned version; override per environment. | `string` | `"1.30"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the cluster is created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Managed Kubernetes Cluster (AKS). | `string` | n/a | yes |
| <a name="input_node_provisioning_profile"></a> [node\_provisioning\_profile](#input\_node\_provisioning\_profile) | Node provisioning profile. mode = "Manual" (default) or "Auto" for Node Auto Provisioning (NAP/Karpenter). Auto mode requires network\_plugin = azure + overlay. | <pre>object({<br/>    mode = optional(string, "Manual")<br/>  })</pre> | `{}` | no |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | Enable the OIDC issuer (required for Workload Identity). Default true. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group where the cluster is created. | `string` | n/a | yes |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | Enable Kubernetes RBAC. Default true. | `bool` | `true` | no |
| <a name="input_service_principal"></a> [service\_principal](#input\_service\_principal) | Service principal block. Use this OR identity. Prefer managed identity where possible. | <pre>object({<br/>    client_id     = string<br/>    client_secret = string<br/>  })</pre> | `null` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | Control-plane SKU tier: Free, Standard or Premium. Default Free. | `string` | `"Free"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the cluster. | `map(string)` | `{}` | no |
| <a name="input_workload_identity_enabled"></a> [workload\_identity\_enabled](#input\_workload\_identity\_enabled) | Enable Azure AD Workload Identity. Requires oidc\_issuer\_enabled = true. Default true. | `bool` | `true` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Resource ID of the AKS cluster. |
| <a name="output_key_vault_secrets_provider_identity"></a> [key\_vault\_secrets\_provider\_identity](#output\_key\_vault\_secrets\_provider\_identity) | Managed identity used by the Key Vault Secrets Provider add-on, when enabled. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw kubeconfig for the cluster. |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | Kubelet identity object (client\_id, object\_id, user\_assigned\_identity\_id). Useful for Key Vault RBAC grants. |
| <a name="output_name"></a> [name](#output\_name) | Name of the AKS cluster. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | Auto-generated resource group holding the node pool infrastructure. |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL (used for Workload Identity federation). |
