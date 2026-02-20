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
      service_endpoints    = ["Microsoft.ContainerRegistry"]
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
          (module.network.subnet["snet-app-mms"].name) = {
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
  kubernetes_cluster = {
    aksmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      dns_prefix          = "mms"
      default_node_pool = {
        name            = "main"
        vm_size         = "Standard_DS2_v2"
        os_disk_size_gb = 30
        vnet_subnet_id  = module.network.subnet["snet-app-mms"].id
        kubelet_config = {
          container_log_max_size_mb = 1024
        }
        linux_os_config = {
          swap_file_size_mb = 512
          sysctl_config = {
            vm_swappiness = 1
          }
        }
        upgrade_settings = {
          max_surge = 50
        }
        tags = {
          project     = "mms-github"
          environment = terraform.workspace
          managed-by  = "terraform"
        }
      }
      api_server_access_profile = {
        authorized_ip_ranges = ["127.0.0.2/32"]
      }
      auto_scaler_profile = {
        max_unready_nodes = 1
      }
      azure_active_directory_role_based_access_control = {
        admin_group_object_ids = ["AAD-GROUP-OBJECT-ID"]
        azure_rbac_enabled     = true
      }
      maintenance_window = {
        allowed = {
          mo = {
            day   = "Monday"
            hours = [5, 6]
          }
          mi = {
            day   = "Wednesday"
            hours = [5, 6]
          }
        }
      }
      maintenance_window_auto_upgrade = {
        frequency   = "Weekly"
        interval    = 1
        duration    = 4
        day_of_week = "Tuesday"
        start_time  = "01:00"
      }
      maintenance_window_node_os = {
        frequency   = "Weekly"
        interval    = 1
        duration    = 4
        day_of_week = "Thursday"
        start_time  = "01:00"
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
}
