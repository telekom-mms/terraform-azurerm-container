module "container" {
  source = "registry.terraform.io/telekom-mms/container/azurerm"
  container_registry = {
    crmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
  kubernetes_cluster = {
    aksmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
}
