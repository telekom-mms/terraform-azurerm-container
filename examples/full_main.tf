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
      sku                 = "Premium"
      network_rule_set = {
        ip_rule = {
          proxy = {
            ip_range = "172.0.0.2/32"
          }
        }
        virtual_network = {
          module.network.subnet["snet-app-mms"].name = {
            subnet_id = module.network.subnet["snet-app-mms"].id
          }
        }
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
}
