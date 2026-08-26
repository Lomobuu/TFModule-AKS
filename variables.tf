### Core

variable "name" {
  description = "Name of the Managed Kubernetes Cluster (AKS)."
  type        = string
}

variable "location" {
  description = "Azure region where the cluster is created."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the cluster is created."
  type        = string
}

variable "tags" {
  description = "Tags applied to the cluster."
  type        = map(string)
  default     = {}
}

### Default (system) node pool

variable "default_node_pool" {
  description = "Configuration for the system (default) node pool. Required by AKS."
  type = object({
    name                         = string
    vm_size                      = string
    node_count                   = optional(number, 2)
    auto_scaling_enabled         = optional(bool, false)
    min_count                    = optional(number)
    max_count                    = optional(number)
    max_pods                     = optional(number)
    os_disk_size_gb              = optional(number)
    os_sku                       = optional(string)
    vnet_subnet_id               = optional(string)
    zones                        = optional(list(string))
    node_labels                  = optional(map(string))
    only_critical_addons_enabled = optional(bool, false)
    orchestrator_version         = optional(string)
    type                         = optional(string, "VirtualMachineScaleSets")
    # Required by AKS when the node pool needs to be rotated in place.
    temporary_name_for_rotation = optional(string, "tmpdefault")
  })

  validation {
    condition     = var.default_node_pool.auto_scaling_enabled == false || (var.default_node_pool.min_count != null && var.default_node_pool.max_count != null)
    error_message = "When auto_scaling_enabled is true you must set both min_count and max_count."
  }
}

variable "node_provisioning_profile" {
  description = "Node provisioning profile. mode = \"Manual\" (default) or \"Auto\" for Node Auto Provisioning (NAP/Karpenter). Auto mode requires network_plugin = azure + overlay."
  type = object({
    mode = optional(string, "Manual")
  })
  default = {}

validation {
  condition = (
    var.node_provisioning_profile == null
    ? true
    : contains(["Manual", "Auto"], var.node_provisioning_profile.mode)
  )
  error_message = "node_provisioning_profile.mode must be either \"Manual\" or \"Auto\"."
}
}

### DNS: exactly one of the two (required)

variable "dns_prefix" {
  description = "DNS prefix for a public cluster. Set this OR dns_prefix_private_cluster, not both."
  type        = string
  default     = null
}

variable "dns_prefix_private_cluster" {
  description = "DNS prefix for a private cluster. Set this OR dns_prefix, not both."
  type        = string
  default     = null
}

### Identity: exactly one of the two (required)

variable "identity" {
  description = "Managed identity block. Use this OR service_principal. type = SystemAssigned | UserAssigned."
  type = object({
    type         = optional(string, "SystemAssigned")
    identity_ids = optional(list(string))
  })
  default = {
    type = "SystemAssigned"
  }
}

variable "service_principal" {
  description = "Service principal block. Use this OR identity. Prefer managed identity where possible."
  type = object({
    client_id     = string
    client_secret = string
  })
  default   = null
  sensitive = true
}

### Feature  toggles

variable "aad_rbac_enabled" {
  description = "Enable Azure AD (Entra ID) integration for Kubernetes RBAC. Default true."
  type        = bool
  default     = true
}

variable "aad_rbac" {
  description = "Azure AD RBAC settings, used only when aad_rbac_enabled = true."
  type = object({
    tenant_id              = optional(string)
    admin_group_object_ids = optional(list(string))
    azure_rbac_enabled     = optional(bool, true)
  })
  default = {}
}

variable "azure_policy_enabled" {
  description = "Enable the Azure Policy add-on. Default true."
  type        = bool
  default     = true
}

variable "key_vault_secrets_provider_enabled" {
  description = "Enable the Azure Key Vault Secrets Provider (CSI) add-on. Default true."
  type        = bool
  default     = true
}

variable "key_vault_secrets_provider" {
  description = "Key Vault Secrets Provider settings, used only when key_vault_secrets_provider_enabled = true."
  type = object({
    secret_rotation_enabled  = optional(bool, true)
    secret_rotation_interval = optional(string, "2m")
  })
  default = {}
}

variable "kubernetes_version" {
  description = "Kubernetes control-plane version. Defaults to a pinned version; override per environment."
  type        = string
  default     = "1.30"
}

variable "oidc_issuer_enabled" {
  description = "Enable the OIDC issuer (required for Workload Identity). Default true."
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = "Control-plane SKU tier: Free, Standard or Premium. Default Free."
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of: Free, Standard, Premium."
  }
}


### Entra ID (AAD) integration for Kubernetes RBAC

variable "workload_identity_enabled" {
  description = "Enable Azure AD Workload Identity. Requires oidc_issuer_enabled = true. Default true."
  type        = bool
  default     = true
}

variable "role_based_access_control_enabled" {
  description = "Enable Kubernetes RBAC. Default true."
  type        = bool
  default     = true
}
