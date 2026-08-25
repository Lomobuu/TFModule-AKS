output "id" {
  description = "Resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL (used for Workload Identity federation)."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kubelet_identity" {
  description = "Kubelet identity object (client_id, object_id, user_assigned_identity_id). Useful for Key Vault RBAC grants."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "key_vault_secrets_provider_identity" {
  description = "Managed identity used by the Key Vault Secrets Provider add-on, when enabled."
  value       = try(azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity, null)
}

output "node_resource_group" {
  description = "Auto-generated resource group holding the node pool infrastructure."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the cluster."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}
