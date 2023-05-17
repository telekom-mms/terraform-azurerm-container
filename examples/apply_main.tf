module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/23"]
    }
  }
  subnet = {
    snet-app-mms = {
      resource_group_name  = module.network.virtual_network["vn-app-mms"].resource_group_name
      address_prefixes     = ["173.0.0.0/23"]
      virtual_network_name = module.network.virtual_network["vn-app-mms"].name
    }
  }
}

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
      default_node_pool = {
        name            = "main"
        vm_size         = "Standard_DS2_v2"
        os_disk_size_gb = 30
        vnet_subnet_id  = module.network.subnet["snet-app-mms"].id
      }
    }
  }
}
