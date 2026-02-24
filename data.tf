data "azurerm_kubernetes_service_versions" "kubernetes_service_versions" {
  for_each = var.kubernetes_cluster

  location        = local.kubernetes_cluster[each.key].location
  include_preview = false
}
