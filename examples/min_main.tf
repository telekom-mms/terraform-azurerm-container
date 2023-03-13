module "container" {
  source = "registry.terraform.io/T-Systems-MMS/container/azurerm"
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
