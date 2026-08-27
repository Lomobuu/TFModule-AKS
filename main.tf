resource "azurerm_kubernetes_cluster" "this" {

  # Core
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # DNS: exactly one of these is set (enforced by the precondition below).
  dns_prefix                 = var.dns_prefix
  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  kubernetes_version = var.kubernetes_version
  sku_tier           = var.sku_tier

  # Feature toggles that map directly to top-level arguments.
  azure_policy_enabled              = var.azure_policy_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled
  workload_identity_enabled         = var.workload_identity_enabled
  role_based_access_control_enabled = var.role_based_access_control_enabled

  # System / default node pool (required).
  default_node_pool {
    name    = var.default_node_pool.name
    vm_size = var.default_node_pool.vm_size
    type    = var.default_node_pool.type

    node_count           = local.default_node_count
    auto_scaling_enabled = var.default_node_pool.auto_scaling_enabled
    min_count            = var.default_node_pool.auto_scaling_enabled ? var.default_node_pool.min_count : null
    max_count            = var.default_node_pool.auto_scaling_enabled ? var.default_node_pool.max_count : null

    max_pods                     = var.default_node_pool.max_pods
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    os_sku                       = var.default_node_pool.os_sku
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = var.default_node_pool.zones
    node_labels                  = var.default_node_pool.node_labels
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons_enabled
    orchestrator_version         = var.default_node_pool.orchestrator_version
    temporary_name_for_rotation  = var.default_node_pool.temporary_name_for_rotation
  }

  # Node provisioning profile
  node_provisioning_profile {
    mode = var.node_provisioning_profile.mode
  }

  # Identity OR service principal (exactly one, enforced by precondition).
  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "service_principal" {
    for_each = var.service_principal == null ? [] : [var.service_principal]

    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  # Azure AD (Entra ID) integration for Kubernetes RBAC. Optional, default on.
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.aad_rbac_enabled ? [var.aad_rbac] : []

    content {
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
    }
  }

  # Key Vault Secrets Provider (CSI) add-on. Optional, default on.
  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? [var.key_vault_secrets_provider] : []

    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  tags = local.tags

  lifecycle {
    # Prevent accidental destroy of the cluster. ALWAYS ON FOR STATEFUL PLATFORM RESOURCES!
    prevent_destroy = true

    # Enforce the "one of" contracts the AKS API also expects.
    precondition {
      condition     = (var.dns_prefix == null) != (var.dns_prefix_private_cluster == null)
      error_message = "Set exactly one of dns_prefix or dns_prefix_private_cluster."
    }

    precondition {
      condition     = (var.identity == null) != (var.service_principal == null)
      error_message = "Set exactly one of identity or service_principal."
    }
  }
}
