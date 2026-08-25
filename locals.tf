locals {
  # Only pass node_count when autoscaling is off; otherwise AKS manages it.
  default_node_count = var.default_node_pool.auto_scaling_enabled ? null : var.default_node_pool.node_count

  # Merge a small set of module-managed tags with caller-supplied ones.
  tags = merge(
    {
      "managed-by" = "terraform"
      "module"     = "aks"
    },
    var.tags
  )
}
