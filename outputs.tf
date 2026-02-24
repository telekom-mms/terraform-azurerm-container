output "container_registry" {
  description = "Outputs all attributes of resource_type."
  value = {
    for container_registry in keys(azurerm_container_registry.container_registry) :
    container_registry => {
      for key, value in azurerm_container_registry.container_registry[container_registry] :
      key => value
    }
  }
}

output "kubernetes_cluster" {
  description = "Outputs all attributes of resource_type."
  value = {
    for kubernetes_cluster in keys(azurerm_kubernetes_cluster.kubernetes_cluster) :
    kubernetes_cluster => {
      for key, value in azurerm_kubernetes_cluster.kubernetes_cluster[kubernetes_cluster] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      container_registry = {
        for key in keys(var.container_registry) :
        key => local.container_registry[key]
      }
      kubernetes_cluster = {
        for key in keys(var.kubernetes_cluster) :
        key => local.kubernetes_cluster[key]
      }
    }
  }
}
