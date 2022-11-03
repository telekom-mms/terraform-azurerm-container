# replace resource_type and local_name with your usecase
# e.g. resource_type = azurerm_container_registry, local_name = container_registry

output "local_name" {
  description = "Outputs all attributes of resource_type."
  value = {
    for local_name in keys(resource_type.local_name) :
    local_name => {
      for key, value in resource_type.local_name[local_name] :
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
      local_name = {
        for key in keys(var.local_name) :
        key => local.local_name[key]
      }
    }
  }
}
