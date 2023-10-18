variable "container_registry" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

variable "kubernetes_cluster" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    container_registry = {
      name                          = ""
      sku                           = "Basic"
      admin_enabled                 = false
      public_network_access_enabled = null
      quarantine_policy_enabled     = null
      zone_redundancy_enabled       = null
      export_policy_enabled         = null
      network_rule_bypass_option    = "None" // disallows default AzureServices as enabled for access
      anonymous_pull_enabled        = null
      data_endpoint_enabled         = null
      network_rule_set = {
        default_action = "Deny" // behaviour for requests matching no rules
        ip_rule = {
          action = "Allow"
        }
        virtual_network = {
          action = "Allow"
        }
      }
      retention_policy = {
        days    = 7
        enabled = true
      }
      trust_policy = {
        enabled = false
      }
      identity = {
        type         = null
        identity_ids = null
      }
      encryption = {
        enabled            = false
        key_vault_key_id   = null
        identity_client_id = null
      }
      georeplications = {
        location                  = ""
        regional_endpoint_enabled = false
        zone_redundancy_enabled   = false
        tags                      = {}
      }
      tags = {}
    }
    kubernetes_cluster = {
      name                                = ""
      dns_prefix                          = null
      dns_prefix_private_cluster          = null
      automatic_channel_upgrade           = "stable" // latest patch version -1
      azure_policy_enabled                = null
      custom_ca_trust_certificates_base64 = null
      disk_encryption_set_id              = null
      edge_zone                           = null
      http_application_routing_enabled    = null
      image_cleaner_enabled               = null
      image_cleaner_interval_hours        = null
      kubernetes_version                  = null
      local_account_disabled              = null
      node_os_channel_upgrade             = null
      node_resource_group                 = null
      oidc_issuer_enabled                 = null
      open_service_mesh_enabled           = null
      private_cluster_enabled             = null
      private_dns_zone_id                 = null
      private_cluster_public_fqdn_enabled = null
      public_network_access_enabled       = null
      role_based_access_control_enabled   = true
      run_command_enabled                 = null
      sku_tier                            = "Standard"
      workload_identity_enabled           = null
      default_node_pool = {
        capacity_reservation_group_id = null
        custom_ca_trust_enabled       = null
        enable_auto_scaling           = true
        enable_host_encryption        = null
        enable_node_public_ip         = null
        host_group_id                 = null
        fips_enabled                  = null
        kubelet_disk_type             = null
        max_pods                      = null
        message_of_the_day            = null
        node_public_ip_prefix_id      = null
        node_labels                   = null
        node_taints                   = null
        only_critical_addons_enabled  = null
        orchestrator_version          = null
        os_disk_size_gb               = null
        os_disk_type                  = "Ephemeral"
        os_sku                        = "Ubuntu"
        pod_subnet_id                 = null
        proximity_placement_group_id  = null
        scale_down_mode               = null
        snapshot_id                   = null
        type                          = "VirtualMachineScaleSets"
        ultra_ssd_enabled             = null
        max_count                     = 10
        min_count                     = 2
        node_count                    = 2
        workload_runtime              = null
        zones                         = [1, 2, 3]
        temporary_name_for_rotation   = "tmppool"
        kubelet_config = {
          allowed_unsafe_sysctls    = null
          container_log_max_line    = null
          container_log_max_size_mb = null
          cpu_cfs_quota_enabled     = null
          cpu_cfs_quota_period      = null
          cpu_manager_policy        = null
          image_gc_high_threshold   = null
          image_gc_low_threshold    = null
          pod_max_pid               = null
          topology_manager_policy   = null
        }
        linux_os_config = {
          swap_file_size_mb             = null
          transparent_huge_page_defrag  = null
          transparent_huge_page_enabled = null
          sysctl_config = {
            fs_aio_max_nr                      = null
            fs_file_max                        = null
            fs_inotify_max_user_watches        = null
            fs_nr_open                         = null
            kernel_threads_max                 = null
            net_core_netdev_max_backlog        = null
            net_core_optmem_max                = null
            net_core_rmem_default              = null
            net_core_rmem_max                  = null
            net_core_somaxconn                 = null
            net_core_wmem_default              = null
            net_core_wmem_max                  = null
            net_ipv4_ip_local_port_range_max   = null
            net_ipv4_ip_local_port_range_min   = null
            net_ipv4_neigh_default_gc_thresh1  = null
            net_ipv4_neigh_default_gc_thresh2  = null
            net_ipv4_neigh_default_gc_thresh3  = null
            net_ipv4_tcp_fin_timeout           = null
            net_ipv4_tcp_keepalive_intvl       = null
            net_ipv4_tcp_keepalive_probes      = null
            net_ipv4_tcp_keepalive_time        = null
            net_ipv4_tcp_max_syn_backlog       = null
            net_ipv4_tcp_max_tw_buckets        = null
            net_ipv4_tcp_tw_reuse              = null
            net_netfilter_nf_conntrack_buckets = null
            net_netfilter_nf_conntrack_max     = null
            vm_max_map_count                   = null
            vm_swappiness                      = null
            vm_vfs_cache_pressure              = null
          }
        }
        node_network_profile = {}
        upgrade_settings     = {}
        tags                 = {}
      }
      aci_connector_linux = {}
      api_server_access_profile = {
        authorized_ip_ranges     = null
        subnet_id                = null
        vnet_integration_enabled = null
      }
      auto_scaler_profile = {
        balance_similar_node_groups      = null
        expander                         = null
        max_graceful_termination_sec     = null
        max_node_provisioning_time       = null
        max_unready_nodes                = null
        max_unready_percentage           = null
        new_pod_scale_up_delay           = null
        scale_down_delay_after_add       = null
        scale_down_delay_after_delete    = null
        scale_down_delay_after_failure   = null
        scan_interval                    = null
        scale_down_unneeded              = null
        scale_down_unready               = null
        scale_down_utilization_threshold = null
        empty_bulk_delete_max            = null
        skip_nodes_with_local_storage    = null
        skip_nodes_with_system_pods      = null
      }
      azure_active_directory_role_based_access_control = {
        managed                = null
        tenant_id              = null
        admin_group_object_ids = null
        azure_rbac_enabled     = null
        client_app_id          = null
        server_app_id          = null
        server_app_secret      = null
      }
      confidential_computing = {}
      http_proxy_config = {
        http_proxy  = null
        https_proxy = null
        no_proxy    = null
        trusted_ca  = null
      }
      identity = {
        type         = "SystemAssigned"
        identity_ids = null
      }
      ingress_application_gateway = {
        gateway_id   = null
        gateway_name = null
        subnet_cidr  = null
        subnet_id    = null
      }
      key_management_service = {
        key_vault_key_id         = ""
        key_vault_network_access = null
      }
      key_vault_secrets_provider = {
        secret_rotation_enabled  = null
        secret_rotation_interval = null
      }
      kubelet_identity = {
        client_id                 = null
        object_id                 = null
        user_assigned_identity_id = null
      }
      linux_profile = {}
      maintenance_window = {
        allowed     = {}
        not_allowed = {}
      }
      maintenance_window_auto_upgrade = {
        day_of_week = null
        week_index  = null
        start_time  = null
        utc_offset  = null
        start_date  = null
        not_allowed = {}
      }
      maintenance_window_node_os = {
        day_of_week = null
        week_index  = null
        start_time  = null
        utc_offset  = null
        start_date  = null
        not_allowed = {}
      }
      microsoft_defender = {}
      monitor_metrics = {
        annotations_allowed = null
        labels_allowed      = null
      }
      network_profile = {
        network_plugin      = "azure"
        network_mode        = null
        network_policy      = "azure"
        dns_service_ip      = null
        ebpf_data_plane     = null
        network_plugin_mode = null
        outbound_type       = "loadBalancer"
        pod_cidr            = null
        pod_cidrs           = null
        service_cidr        = null
        service_cidrs       = null
        ip_versions         = ["IPv4"]
        load_balancer_sku   = "standard"
        load_balancer_profile = {
          idle_timeout_in_minutes     = null
          managed_outbound_ip_count   = null
          managed_outbound_ipv6_count = null
          outbound_ip_address_ids     = null
          outbound_ip_prefix_ids      = null
          outbound_ports_allocated    = null
        }
        nat_gateway_profile = {
          idle_timeout_in_minutes   = null
          managed_outbound_ip_count = null
        }
      }
      oms_agent = {
        msi_auth_for_monitoring_enabled = null
      }
      workload_autoscaler_profile = {
        keda_enabled                    = null
        vertical_pod_autoscaler_enabled = null
      }
      service_principal = {}
      storage_profile = {
        blob_driver_enabled         = null
        disk_driver_enabled         = null
        disk_driver_version         = null
        file_driver_enabled         = null
        snapshot_controller_enabled = null
      }
      web_app_routing = {}
      windows_profile = {
        admin_username = ""
        admin_password = null
        license        = null
        gmsa           = {}
      }
      tags = {}
    }
  }

  // compare and merge custom and default values
  container_registry_values = {
    for container_registry in keys(var.container_registry) :
    container_registry => merge(local.default.container_registry, var.container_registry[container_registry])
  }
  kubernetes_cluster_values = {
    for kubernetes_cluster in keys(var.kubernetes_cluster) :
    kubernetes_cluster => merge(local.default.kubernetes_cluster, var.kubernetes_cluster[kubernetes_cluster])
  }

  // deep merge of all custom and default values
  container_registry = {
    for container_registry in keys(var.container_registry) :
    container_registry => merge(
      local.container_registry_values[container_registry],
      {
        for config in ["retention_policy", "trust_policy", "identity", "encryption", "georeplications"] :
        config => merge(local.default.container_registry[config], local.container_registry_values[container_registry][config])
      },
      {
        for config in ["network_rule_set"] :
        config => merge(
          merge(local.default.container_registry[config], local.container_registry_values[container_registry][config]),
          {
            for subconfig in ["ip_rule", "virtual_network"] :
            subconfig => {
              for key in keys(lookup(local.container_registry_values[container_registry][config], subconfig, {})) :
              key => keys(local.container_registry_values[container_registry][config][subconfig]) == keys(local.default.container_registry[config][subconfig]) ? {} : merge(local.default.container_registry[config][subconfig], local.container_registry_values[container_registry].network_rule_set[subconfig][key])
            }
          }
        )
      }
    )
  }
  kubernetes_cluster = {
    for kubernetes_cluster in keys(var.kubernetes_cluster) :
    kubernetes_cluster => merge(
      local.kubernetes_cluster_values[kubernetes_cluster],
      {
        for config in [
          "api_server_access_profile",
          "auto_scaler_profile",
          "azure_active_directory_role_based_access_control",
          "confidential_computing",
          "http_proxy_config",
          "identity",
          "ingress_application_gateway",
          "key_management_service",
          "key_vault_secrets_provider",
          "kubelet_identity",
          "linux_profile",
          "maintenance_window",
          "microsoft_defender",
          "monitor_metrics",
          "oms_agent",
          "workload_autoscaler_profile",
          "service_principal",
          "storage_profile",
          "web_app_routing"
        ] :
        config => merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config])
      },
      {
        for config in ["default_node_pool"] :
        config => merge(
          merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config]),
          {
            for subconfig in ["kubelet_config", "node_network_profile", "upgrade_settings"] :
            subconfig => merge(local.default.kubernetes_cluster[config][subconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config], subconfig, {}))
          },
          {
            for subconfig in ["linux_os_config"] :
            subconfig => merge(
              merge(local.default.kubernetes_cluster[config][subconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config], subconfig, {})),
              lookup(var.kubernetes_cluster[kubernetes_cluster][config], subconfig, {}) == {} ? {} : {
                for subsubconfig in ["sysctl_config"] :
                subsubconfig => merge(local.default.kubernetes_cluster[config][subconfig][subsubconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config][subconfig], subsubconfig, {}))
              }
            )
          }
        )
      },
      {
        for config in ["network_profile"] :
        config => merge(
          merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config]),
          {
            for subconfig in ["load_balancer_profile", "nat_gateway_profile"] :
            subconfig => merge(local.default.kubernetes_cluster[config][subconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config], subconfig, {}))
          }
        )
      },
      {
        for config in ["windows_profile"] :
        config => merge(
          merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config]),
          {
            for subconfig in ["gmsa"] :
            subconfig => merge(local.default.kubernetes_cluster[config][subconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config], subconfig, {}))
          }
        )
      },
      {
        for config in ["maintenance_window_auto_upgrade", "maintenance_window_node_os"] :
        config => merge(
          merge(local.default.kubernetes_cluster[config], local.kubernetes_cluster_values[kubernetes_cluster][config]),
          {
            for subconfig in ["not_allowed"] :
            subconfig => merge(local.default.kubernetes_cluster[config][subconfig], lookup(local.kubernetes_cluster_values[kubernetes_cluster][config], subconfig, {}))
          }
        )
      }
    )
  }
}
