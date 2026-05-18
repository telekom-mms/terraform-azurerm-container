/**
* # container
*
* This module manages the hashicorp/azurerm container resources.
* For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs > container
*
*/

resource "azurerm_container_registry" "container_registry" {
  #ts:skip=AC_AZURE_0185 terrascan - resource lock not part of this module
  for_each = var.container_registry

  name                          = local.container_registry[each.key].name == "" ? each.key : local.container_registry[each.key].name
  location                      = local.container_registry[each.key].location
  resource_group_name           = local.container_registry[each.key].resource_group_name
  sku                           = local.container_registry[each.key].sku
  admin_enabled                 = local.container_registry[each.key].admin_enabled
  public_network_access_enabled = local.container_registry[each.key].public_network_access_enabled
  quarantine_policy_enabled     = local.container_registry[each.key].quarantine_policy_enabled
  zone_redundancy_enabled       = local.container_registry[each.key].zone_redundancy_enabled
  export_policy_enabled         = local.container_registry[each.key].export_policy_enabled
  network_rule_bypass_option    = local.container_registry[each.key].network_rule_bypass_option
  anonymous_pull_enabled        = local.container_registry[each.key].anonymous_pull_enabled
  data_endpoint_enabled         = local.container_registry[each.key].data_endpoint_enabled
  retention_policy_in_days      = local.container_registry[each.key].retention_policy_in_days
  trust_policy_enabled          = local.container_registry[each.key].trust_policy_enabled

  // policy can only be applied when using the Premium sku
  dynamic "network_rule_set" {
    for_each = try(local.container_registry[each.key].sku == "Premium", false) ? [0] : []

    content {
      default_action = local.container_registry[each.key].network_rule_set.default_action

      // ip_rule and / or virtual_network are optional
      dynamic "ip_rule" {
        for_each = try(length(keys(local.container_registry[each.key].network_rule_set.ip_rule)) > 0 && !contains(keys(local.container_registry[each.key].network_rule_set.ip_rule), "action"), false) ? keys(local.container_registry[each.key].network_rule_set.ip_rule) : []

        content {
          action   = local.container_registry[each.key].network_rule_set.ip_rule[ip_rule.key].action
          ip_range = local.container_registry[each.key].network_rule_set.ip_rule[ip_rule.key].ip_range
        }
      }
    }
  }

  dynamic "identity" {
    for_each = try(local.container_registry[each.key].identity.type != null, false) ? [0] : []

    content {
      type         = local.container_registry[each.key].identity.type
      identity_ids = local.container_registry[each.key].identity.identity_ids
    }
  }

  dynamic "encryption" {
    for_each = try(length([for v in values(local.container_registry[each.key].encryption) : v if v != null]) > 0, false) ? [1] : []

    content {
      key_vault_key_id   = local.container_registry[each.key].encryption.key_vault_key_id
      identity_client_id = local.container_registry[each.key].encryption.identity_client_id
    }
  }

  // policy can only be applied when using the Premium sku
  dynamic "georeplications" {
    for_each = try(local.container_registry[each.key].sku == "Premium" && local.container_registry[each.key].georeplications.location != "", false) ? [0] : []

    content {
      location                  = local.container_registry[each.key].georeplications.location
      regional_endpoint_enabled = local.container_registry[each.key].georeplications.regional_endpoint_enabled
      zone_redundancy_enabled   = local.container_registry[each.key].georeplications.zone_redundancy_enabled
      tags                      = local.container_registry[each.key].georeplications.tags
    }
  }

  tags = local.container_registry[each.key].tags
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each = var.kubernetes_cluster

  name                                = local.kubernetes_cluster[each.key].name == "" ? each.key : local.kubernetes_cluster[each.key].name
  location                            = local.kubernetes_cluster[each.key].location
  resource_group_name                 = local.kubernetes_cluster[each.key].resource_group_name
  dns_prefix                          = local.kubernetes_cluster[each.key].dns_prefix != null ? local.kubernetes_cluster[each.key].dns_prefix : null
  dns_prefix_private_cluster          = local.kubernetes_cluster[each.key].dns_prefix_private_cluster != null ? local.kubernetes_cluster[each.key].dns_prefix_private_cluster : null
  ai_toolchain_operator_enabled       = local.kubernetes_cluster[each.key].ai_toolchain_operator_enabled
  automatic_upgrade_channel           = local.kubernetes_cluster[each.key].automatic_upgrade_channel
  azure_policy_enabled                = local.kubernetes_cluster[each.key].azure_policy_enabled
  cost_analysis_enabled               = local.kubernetes_cluster[each.key].cost_analysis_enabled
  custom_ca_trust_certificates_base64 = local.kubernetes_cluster[each.key].custom_ca_trust_certificates_base64
  disk_encryption_set_id              = local.kubernetes_cluster[each.key].disk_encryption_set_id
  edge_zone                           = local.kubernetes_cluster[each.key].edge_zone
  http_application_routing_enabled    = local.kubernetes_cluster[each.key].http_application_routing_enabled
  image_cleaner_enabled               = local.kubernetes_cluster[each.key].image_cleaner_enabled
  image_cleaner_interval_hours        = local.kubernetes_cluster[each.key].image_cleaner_interval_hours
  kubernetes_version                  = local.kubernetes_cluster[each.key].automatic_upgrade_channel != null ? local.kubernetes_cluster[each.key].kubernetes_version : local.kubernetes_cluster[each.key].kubernetes_version == null ? data.azurerm_kubernetes_service_versions.kubernetes_service_versions[each.key].latest_version : local.kubernetes_cluster[each.key].kubernetes_version
  local_account_disabled              = local.kubernetes_cluster[each.key].local_account_disabled
  node_os_upgrade_channel             = local.kubernetes_cluster[each.key].node_os_upgrade_channel
  node_resource_group                 = local.kubernetes_cluster[each.key].node_resource_group
  oidc_issuer_enabled                 = local.kubernetes_cluster[each.key].oidc_issuer_enabled
  open_service_mesh_enabled           = local.kubernetes_cluster[each.key].open_service_mesh_enabled
  private_cluster_enabled             = local.kubernetes_cluster[each.key].private_cluster_enabled
  private_dns_zone_id                 = local.kubernetes_cluster[each.key].private_dns_zone_id
  private_cluster_public_fqdn_enabled = local.kubernetes_cluster[each.key].private_cluster_public_fqdn_enabled
  role_based_access_control_enabled   = local.kubernetes_cluster[each.key].role_based_access_control_enabled
  run_command_enabled                 = local.kubernetes_cluster[each.key].run_command_enabled
  sku_tier                            = local.kubernetes_cluster[each.key].sku_tier
  support_plan                        = local.kubernetes_cluster[each.key].support_plan
  workload_identity_enabled           = local.kubernetes_cluster[each.key].workload_identity_enabled

  default_node_pool {
    name                          = local.kubernetes_cluster[each.key].default_node_pool.name
    vm_size                       = local.kubernetes_cluster[each.key].default_node_pool.vm_size
    capacity_reservation_group_id = local.kubernetes_cluster[each.key].default_node_pool.capacity_reservation_group_id
    auto_scaling_enabled          = local.kubernetes_cluster[each.key].default_node_pool.auto_scaling_enabled
    host_encryption_enabled       = local.kubernetes_cluster[each.key].default_node_pool.host_encryption_enabled
    node_public_ip_enabled        = local.kubernetes_cluster[each.key].default_node_pool.node_public_ip_enabled
    host_group_id                 = local.kubernetes_cluster[each.key].default_node_pool.host_group_id
    fips_enabled                  = local.kubernetes_cluster[each.key].default_node_pool.fips_enabled
    kubelet_disk_type             = local.kubernetes_cluster[each.key].default_node_pool.kubelet_disk_type
    max_pods                      = local.kubernetes_cluster[each.key].default_node_pool.max_pods
    node_public_ip_prefix_id      = local.kubernetes_cluster[each.key].default_node_pool.node_public_ip_prefix_id
    node_labels                   = local.kubernetes_cluster[each.key].default_node_pool.node_labels
    only_critical_addons_enabled  = local.kubernetes_cluster[each.key].default_node_pool.only_critical_addons_enabled
    orchestrator_version          = local.kubernetes_cluster[each.key].automatic_upgrade_channel != null ? local.kubernetes_cluster[each.key].default_node_pool.orchestrator_version : local.kubernetes_cluster[each.key].default_node_pool.orchestrator_version == null ? data.azurerm_kubernetes_service_versions.kubernetes_service_versions[each.key].latest_version : local.kubernetes_cluster[each.key].default_node_pool.orchestrator_version
    os_disk_size_gb               = local.kubernetes_cluster[each.key].default_node_pool.os_disk_size_gb
    os_disk_type                  = local.kubernetes_cluster[each.key].default_node_pool.os_disk_type
    os_sku                        = local.kubernetes_cluster[each.key].default_node_pool.os_sku
    pod_subnet_id                 = local.kubernetes_cluster[each.key].default_node_pool.pod_subnet_id
    proximity_placement_group_id  = local.kubernetes_cluster[each.key].default_node_pool.proximity_placement_group_id
    scale_down_mode               = local.kubernetes_cluster[each.key].default_node_pool.scale_down_mode
    snapshot_id                   = local.kubernetes_cluster[each.key].default_node_pool.snapshot_id
    type                          = local.kubernetes_cluster[each.key].default_node_pool.type
    ultra_ssd_enabled             = local.kubernetes_cluster[each.key].default_node_pool.ultra_ssd_enabled
    vnet_subnet_id                = local.kubernetes_cluster[each.key].network_profile.network_plugin == "azure" ? local.kubernetes_cluster[each.key].default_node_pool.vnet_subnet_id : null
    max_count                     = local.kubernetes_cluster[each.key].default_node_pool.auto_scaling_enabled == true ? local.kubernetes_cluster[each.key].default_node_pool.max_count : null
    min_count                     = local.kubernetes_cluster[each.key].default_node_pool.auto_scaling_enabled == true ? local.kubernetes_cluster[each.key].default_node_pool.min_count : null
    node_count                    = local.kubernetes_cluster[each.key].default_node_pool.node_count
    workload_runtime              = local.kubernetes_cluster[each.key].default_node_pool.auto_scaling_enabled == false ? local.kubernetes_cluster[each.key].default_node_pool.workload_runtime : null
    zones                         = local.kubernetes_cluster[each.key].default_node_pool.auto_scaling_enabled == false ? local.kubernetes_cluster[each.key].default_node_pool.zones : null
    temporary_name_for_rotation   = local.kubernetes_cluster[each.key].default_node_pool.temporary_name_for_rotation

    dynamic "kubelet_config" {
      for_each = try(length([for v in values(local.kubernetes_cluster[each.key].default_node_pool.kubelet_config) : v if v != null]) > 0, false) ? [1] : []

      content {
        allowed_unsafe_sysctls  = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.allowed_unsafe_sysctls
        container_log_max_files = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.container_log_max_files
        image_gc_high_threshold = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.image_gc_high_threshold
        image_gc_low_threshold  = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.image_gc_low_threshold
        pod_max_pid             = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.pod_max_pid
        topology_manager_policy = local.kubernetes_cluster[each.key].default_node_pool.kubelet_config.topology_manager_policy
      }
    }

    dynamic "linux_os_config" {
      for_each = try(length([for v in concat([for key in setsubtract(keys(local.kubernetes_cluster[each.key].default_node_pool.linux_os_config), ["sysctl_config"]) : local.kubernetes_cluster[each.key].default_node_pool.linux_os_config[key]], values(lookup(local.kubernetes_cluster[each.key].default_node_pool.linux_os_config, "sysctl_config", {}))) : v if v != null]) > 0, false) ? [1] : []

      content {
        swap_file_size_mb            = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.swap_file_size_mb
        transparent_huge_page_defrag = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.transparent_huge_page_defrag
        transparent_huge_page        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.transparent_huge_page

        dynamic "sysctl_config" {
          for_each = try(length([for v in values(local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config) : v if v != null]) > 0, false) ? [1] : []

          content {
            fs_aio_max_nr                      = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.fs_aio_max_nr
            fs_file_max                        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.fs_file_max
            fs_inotify_max_user_watches        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.fs_inotify_max_user_watches
            fs_nr_open                         = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.fs_nr_open
            kernel_threads_max                 = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.kernel_threads_max
            net_core_netdev_max_backlog        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_netdev_max_backlog
            net_core_optmem_max                = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_optmem_max
            net_core_rmem_default              = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_rmem_default
            net_core_rmem_max                  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_rmem_max
            net_core_somaxconn                 = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_somaxconn
            net_core_wmem_default              = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_wmem_default
            net_core_wmem_max                  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_core_wmem_max
            net_ipv4_ip_local_port_range_max   = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max
            net_ipv4_ip_local_port_range_min   = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min
            net_ipv4_neigh_default_gc_thresh1  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1
            net_ipv4_neigh_default_gc_thresh2  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2
            net_ipv4_neigh_default_gc_thresh3  = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3
            net_ipv4_tcp_fin_timeout           = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout
            net_ipv4_tcp_keepalive_intvl       = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl
            net_ipv4_tcp_keepalive_probes      = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes
            net_ipv4_tcp_keepalive_time        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time
            net_ipv4_tcp_max_syn_backlog       = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog
            net_ipv4_tcp_max_tw_buckets        = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets
            net_ipv4_tcp_tw_reuse              = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse
            net_netfilter_nf_conntrack_buckets = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets
            net_netfilter_nf_conntrack_max     = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max
            vm_max_map_count                   = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.vm_max_map_count
            vm_swappiness                      = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.vm_swappiness
            vm_vfs_cache_pressure              = local.kubernetes_cluster[each.key].default_node_pool.linux_os_config.sysctl_config.vm_vfs_cache_pressure
          }
        }
      }
    }

    dynamic "node_network_profile" {
      for_each = try(length([for v in values(local.kubernetes_cluster[each.key].default_node_pool.node_network_profile) : v if v != null && (!can(keys(v)) || length(keys(v)) > 0)]) > 0, false) ? [1] : []

      content {
        node_public_ip_tags            = local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.node_public_ip_tags
        application_security_group_ids = local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.application_security_group_ids

        dynamic "allowed_host_ports" {
          for_each = try(length(keys(local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.allowed_host_ports)) > 0, false) ? keys(local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.allowed_host_ports) : []

          content {
            port_start = local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.allowed_host_ports[allowed_host_ports.key].port_start
            port_end   = local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.allowed_host_ports[allowed_host_ports.key].port_end
            protocol   = local.kubernetes_cluster[each.key].default_node_pool.node_network_profile.allowed_host_ports[allowed_host_ports.key].protocol
          }
        }
      }
    }

    upgrade_settings {
      drain_timeout_in_minutes      = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.drain_timeout_in_minutes
      node_soak_duration_in_minutes = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.node_soak_duration_in_minutes
      max_surge                     = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.max_surge
      undrainable_node_behavior     = local.kubernetes_cluster[each.key].default_node_pool.upgrade_settings.undrainable_node_behavior
    }

    tags = local.kubernetes_cluster[each.key].default_node_pool.tags
  }

  dynamic "upgrade_override" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].upgrade_override) : v if v != null]) > 0, false) ? [1] : []

    content {
      force_upgrade_enabled = local.kubernetes_cluster[each.key].upgrade_override.force_upgrade_enabled
      effective_until       = local.kubernetes_cluster[each.key].upgrade_override.effective_until
    }
  }

  dynamic "aci_connector_linux" {
    for_each = try(length(keys(local.kubernetes_cluster[each.key].aci_connector_linux)) > 0, false) ? [1] : []

    content {
      subnet_name = local.kubernetes_cluster[each.key].aci_connector_linux.subnet_name
    }
  }

  dynamic "api_server_access_profile" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].api_server_access_profile) : v if v != null]) > 0, false) ? [1] : []

    content {
      authorized_ip_ranges                = local.kubernetes_cluster[each.key].api_server_access_profile.authorized_ip_ranges
      subnet_id                           = local.kubernetes_cluster[each.key].api_server_access_profile.subnet_id
      virtual_network_integration_enabled = local.kubernetes_cluster[each.key].api_server_access_profile.virtual_network_integration_enabled
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].auto_scaler_profile) : v if v != null]) > 0, false) ? [1] : []

    content {
      balance_similar_node_groups                   = local.kubernetes_cluster[each.key].auto_scaler_profile.balance_similar_node_groups
      daemonset_eviction_for_empty_nodes_enabled    = local.kubernetes_cluster[each.key].auto_scaler_profile.daemonset_eviction_for_empty_nodes_enabled
      daemonset_eviction_for_occupied_nodes_enabled = local.kubernetes_cluster[each.key].auto_scaler_profile.daemonset_eviction_for_occupied_nodes_enabled
      expander                                      = local.kubernetes_cluster[each.key].auto_scaler_profile.expander
      ignore_daemonsets_utilization_enabled         = local.kubernetes_cluster[each.key].auto_scaler_profile.ignore_daemonsets_utilization_enabled
      max_graceful_termination_sec                  = local.kubernetes_cluster[each.key].auto_scaler_profile.max_graceful_termination_sec
      max_node_provisioning_time                    = local.kubernetes_cluster[each.key].auto_scaler_profile.max_node_provisioning_time
      max_unready_nodes                             = local.kubernetes_cluster[each.key].auto_scaler_profile.max_unready_nodes
      max_unready_percentage                        = local.kubernetes_cluster[each.key].auto_scaler_profile.max_unready_percentage
      new_pod_scale_up_delay                        = local.kubernetes_cluster[each.key].auto_scaler_profile.new_pod_scale_up_delay
      scale_down_delay_after_add                    = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_add
      scale_down_delay_after_delete                 = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_delete
      scale_down_delay_after_failure                = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_delay_after_failure
      scan_interval                                 = local.kubernetes_cluster[each.key].auto_scaler_profile.scan_interval
      scale_down_unneeded                           = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_unneeded
      scale_down_unready                            = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_unready
      scale_down_utilization_threshold              = local.kubernetes_cluster[each.key].auto_scaler_profile.scale_down_utilization_threshold
      empty_bulk_delete_max                         = local.kubernetes_cluster[each.key].auto_scaler_profile.empty_bulk_delete_max
      skip_nodes_with_local_storage                 = local.kubernetes_cluster[each.key].auto_scaler_profile.skip_nodes_with_local_storage
      skip_nodes_with_system_pods                   = local.kubernetes_cluster[each.key].auto_scaler_profile.skip_nodes_with_system_pods
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control) : v if v != null]) > 0, false) ? [1] : []

    content {
      tenant_id              = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.tenant_id
      admin_group_object_ids = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.admin_group_object_ids
      azure_rbac_enabled     = local.kubernetes_cluster[each.key].azure_active_directory_role_based_access_control.azure_rbac_enabled
    }
  }

  dynamic "confidential_computing" {
    for_each = try(length(keys(local.kubernetes_cluster[each.key].confidential_computing)) > 0, false) ? [1] : []

    content {
      sgx_quote_helper_enabled = local.kubernetes_cluster[each.key].confidential_computing.sgx_quote_helper_enabled
    }
  }

  dynamic "http_proxy_config" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].http_proxy_config) : v if v != null]) > 0, false) ? [1] : []

    content {
      http_proxy  = local.kubernetes_cluster[each.key].http_proxy_config.http_proxy
      https_proxy = local.kubernetes_cluster[each.key].http_proxy_config.https_proxy
      no_proxy    = local.kubernetes_cluster[each.key].http_proxy_config.no_proxy
      trusted_ca  = local.kubernetes_cluster[each.key].http_proxy_config.trusted_ca
    }
  }

  dynamic "identity" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].service_principal) : v if v != null]) == 0, true) ? [1] : []

    content {
      type         = local.kubernetes_cluster[each.key].identity.type
      identity_ids = local.kubernetes_cluster[each.key].identity.identity_ids
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].ingress_application_gateway) : v if v != null]) > 0, false) ? [1] : []

    content {
      gateway_id   = local.kubernetes_cluster[each.key].ingress_application_gateway.gateway_id
      gateway_name = local.kubernetes_cluster[each.key].ingress_application_gateway.gateway_name
      subnet_cidr  = local.kubernetes_cluster[each.key].ingress_application_gateway.subnet_cidr
      subnet_id    = local.kubernetes_cluster[each.key].ingress_application_gateway.subnet_id
    }
  }

  dynamic "key_management_service" {
    for_each = try(local.kubernetes_cluster[each.key].key_management_service.key_vault_key_id != null && local.kubernetes_cluster[each.key].key_management_service.key_vault_key_id != "", false) ? [1] : []

    content {
      key_vault_key_id         = local.kubernetes_cluster[each.key].key_management_service.key_vault_key_id
      key_vault_network_access = local.kubernetes_cluster[each.key].key_management_service.key_vault_network_access
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].key_vault_secrets_provider) : v if v != null]) > 0, false) ? [1] : []

    content {
      secret_rotation_enabled  = local.kubernetes_cluster[each.key].key_vault_secrets_provider.secret_rotation_enabled
      secret_rotation_interval = local.kubernetes_cluster[each.key].key_vault_secrets_provider.secret_rotation_interval
    }
  }

  dynamic "kubelet_identity" {
    for_each = try(local.kubernetes_cluster[each.key].identity.type == "UserAssigned", false) ? [1] : []

    content {
      client_id                 = local.kubernetes_cluster[each.key].kubelet_identity.client_id
      object_id                 = local.kubernetes_cluster[each.key].kubelet_identity.object_id
      user_assigned_identity_id = local.kubernetes_cluster[each.key].kubelet_identity.user_assigned_identity_id
    }
  }

  dynamic "linux_profile" {
    for_each = try(length(keys(local.kubernetes_cluster[each.key].linux_profile)) > 0, false) ? [1] : []

    content {
      admin_username = local.kubernetes_cluster[each.key].linux_profile.admin_username
      ssh_key {
        key_data = local.kubernetes_cluster[each.key].linux_profile.ssh_key.key_data
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = try(length(keys(local.kubernetes_cluster[each.key].maintenance_window.allowed)) > 0 || length(keys(local.kubernetes_cluster[each.key].maintenance_window.not_allowed)) > 0, false) ? [1] : []

    content {

      dynamic "allowed" {
        for_each = try(length(keys(local.kubernetes_cluster[each.key].maintenance_window.allowed)) > 0, false) ? keys(local.kubernetes_cluster[each.key].maintenance_window.allowed) : []

        content {
          day   = local.kubernetes_cluster[each.key].maintenance_window.allowed[allowed.value].day
          hours = local.kubernetes_cluster[each.key].maintenance_window.allowed[allowed.value].hours
        }
      }

      dynamic "not_allowed" {
        for_each = try(length(keys(local.kubernetes_cluster[each.key].maintenance_window.not_allowed)) > 0, false) ? keys(local.kubernetes_cluster[each.key].maintenance_window.not_allowed) : []

        content {
          end   = local.kubernetes_cluster[each.key].maintenance_window.not_allowed[not_allowed.value].end
          start = local.kubernetes_cluster[each.key].maintenance_window.not_allowed[not_allowed.value].start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = try(local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.frequency != null && local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.interval != null && local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.duration != null, false) ? [1] : []

    content {
      frequency   = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.frequency
      interval    = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.interval
      duration    = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.duration
      day_of_week = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.day_of_week
      week_index  = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.week_index
      start_time  = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.start_time
      utc_offset  = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.utc_offset
      start_date  = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.start_date

      dynamic "not_allowed" {
        for_each = try(length(keys(local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.not_allowed)) > 0, false) ? keys(local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.not_allowed) : []

        content {
          end   = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.not_allowed[not_allowed.key].end
          start = local.kubernetes_cluster[each.key].maintenance_window_auto_upgrade.not_allowed[not_allowed.key].start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = try(local.kubernetes_cluster[each.key].maintenance_window_node_os.frequency != null && local.kubernetes_cluster[each.key].maintenance_window_node_os.interval != null && local.kubernetes_cluster[each.key].maintenance_window_node_os.duration != null, false) ? [1] : []


    content {
      frequency   = local.kubernetes_cluster[each.key].maintenance_window_node_os.frequency
      interval    = local.kubernetes_cluster[each.key].maintenance_window_node_os.interval
      duration    = local.kubernetes_cluster[each.key].maintenance_window_node_os.duration
      day_of_week = local.kubernetes_cluster[each.key].maintenance_window_node_os.day_of_week
      week_index  = local.kubernetes_cluster[each.key].maintenance_window_node_os.week_index
      start_time  = local.kubernetes_cluster[each.key].maintenance_window_node_os.start_time
      utc_offset  = local.kubernetes_cluster[each.key].maintenance_window_node_os.utc_offset
      start_date  = local.kubernetes_cluster[each.key].maintenance_window_node_os.start_date

      dynamic "not_allowed" {
        for_each = try(length(keys(local.kubernetes_cluster[each.key].maintenance_window_node_os.not_allowed)) > 0, false) ? keys(local.kubernetes_cluster[each.key].maintenance_window_node_os.not_allowed) : []

        content {
          end   = local.kubernetes_cluster[each.key].maintenance_window_node_os.not_allowed[not_allowed.key].end
          start = local.kubernetes_cluster[each.key].maintenance_window_node_os.not_allowed[not_allowed.key].start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = try(local.kubernetes_cluster[each.key].microsoft_defender.log_analytics_workspace_id != null && local.kubernetes_cluster[each.key].microsoft_defender.log_analytics_workspace_id != "", false) ? [1] : []

    content {
      log_analytics_workspace_id = local.kubernetes_cluster[each.key].microsoft_defender.log_analytics_workspace_id
    }
  }

  dynamic "monitor_metrics" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].monitor_metrics) : v if v != null]) > 0, false) ? [1] : []

    content {
      annotations_allowed = local.kubernetes_cluster[each.key].monitor_metrics.annotations_allowed
      labels_allowed      = local.kubernetes_cluster[each.key].monitor_metrics.labels_allowed
    }
  }

  dynamic "network_profile" {
    for_each = try(local.kubernetes_cluster[each.key].network_profile.network_plugin != "kubenet", false) ? [1] : []

    content {
      network_plugin = local.kubernetes_cluster[each.key].network_profile.network_plugin
      network_mode   = local.kubernetes_cluster[each.key].network_profile.network_mode
      #ts:skip=AC_AZURE_0158 terrascan - enabled over local default setting
      network_policy      = local.kubernetes_cluster[each.key].network_profile.network_policy
      dns_service_ip      = local.kubernetes_cluster[each.key].network_profile.dns_service_ip
      network_data_plane  = local.kubernetes_cluster[each.key].network_profile.network_data_plane
      network_plugin_mode = local.kubernetes_cluster[each.key].network_profile.network_plugin_mode
      outbound_type       = local.kubernetes_cluster[each.key].network_profile.outbound_type
      pod_cidr            = local.kubernetes_cluster[each.key].network_profile.pod_cidr
      pod_cidrs           = local.kubernetes_cluster[each.key].network_profile.pod_cidrs
      service_cidr        = local.kubernetes_cluster[each.key].network_profile.service_cidr
      service_cidrs       = local.kubernetes_cluster[each.key].network_profile.service_cidrs
      ip_versions         = local.kubernetes_cluster[each.key].network_profile.ip_versions
      load_balancer_sku   = local.kubernetes_cluster[each.key].network_profile.load_balancer_sku

      dynamic "advanced_networking" {
        for_each = try(length([for v in values(local.kubernetes_cluster[each.key].network_profile.advanced_networking) : v if v != null]) > 0, false) ? [1] : []

        content {
          observability_enabled = local.kubernetes_cluster[each.key].network_profile.advanced_networking.observability_enabled
          security_enabled      = local.kubernetes_cluster[each.key].network_profile.advanced_networking.security_enabled
        }
      }

      dynamic "load_balancer_profile" {
        for_each = try(length([for v in values(local.kubernetes_cluster[each.key].network_profile.load_balancer_profile) : v if v != null]) > 0, false) ? [1] : []

        content {
          idle_timeout_in_minutes     = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.idle_timeout_in_minutes
          managed_outbound_ip_count   = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.managed_outbound_ip_count
          managed_outbound_ipv6_count = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.managed_outbound_ipv6_count
          outbound_ip_address_ids     = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ip_address_ids
          outbound_ip_prefix_ids      = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ip_prefix_ids
          outbound_ports_allocated    = local.kubernetes_cluster[each.key].network_profile.load_balancer_profile.outbound_ports_allocated
        }
      }

      dynamic "nat_gateway_profile" {
        for_each = try(length([for v in values(local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile) : v if v != null]) > 0, false) ? [1] : []

        content {
          idle_timeout_in_minutes   = local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile.idle_timeout_in_minutes
          managed_outbound_ip_count = local.kubernetes_cluster[each.key].network_profile.nat_gateway_profile.managed_outbound_ip_count
        }
      }
    }
  }

  dynamic "oms_agent" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].oms_agent) : v if v != null]) > 0, false) ? [1] : []

    content {
      log_analytics_workspace_id      = local.kubernetes_cluster[each.key].oms_agent.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = local.kubernetes_cluster[each.key].oms_agent.msi_auth_for_monitoring_enabled
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].workload_autoscaler_profile) : v if v != null]) > 0, false) ? [1] : []

    content {
      keda_enabled                    = local.kubernetes_cluster[each.key].workload_autoscaler_profile.keda_enabled
      vertical_pod_autoscaler_enabled = local.kubernetes_cluster[each.key].workload_autoscaler_profile.vertical_pod_autoscaler_enabled
    }
  }

  dynamic "service_principal" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].service_principal) : v if v != null]) > 0, false) ? [1] : []

    content {
      client_id     = local.kubernetes_cluster[each.key].service_principal.client_id
      client_secret = local.kubernetes_cluster[each.key].service_principal.client_secret
    }
  }

  dynamic "storage_profile" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].storage_profile) : v if v != null]) > 0, false) ? [1] : []

    content {
      blob_driver_enabled         = local.kubernetes_cluster[each.key].storage_profile.blob_driver_enabled
      disk_driver_enabled         = local.kubernetes_cluster[each.key].storage_profile.disk_driver_enabled
      file_driver_enabled         = local.kubernetes_cluster[each.key].storage_profile.file_driver_enabled
      snapshot_controller_enabled = local.kubernetes_cluster[each.key].storage_profile.snapshot_controller_enabled
    }
  }

  dynamic "web_app_routing" {
    for_each = try(length([for v in values(local.kubernetes_cluster[each.key].web_app_routing) : v if v != null]) > 0, false) ? [1] : []

    content {
      dns_zone_ids             = local.kubernetes_cluster[each.key].web_app_routing.dns_zone_ids
      default_nginx_controller = local.kubernetes_cluster[each.key].web_app_routing.default_nginx_controller
    }
  }

  dynamic "windows_profile" {
    for_each = try(local.kubernetes_cluster[each.key].windows_profile.admin_username != null && local.kubernetes_cluster[each.key].windows_profile.admin_username != "", false) ? [1] : []

    content {
      admin_username = local.kubernetes_cluster[each.key].windows_profile.admin_username
      admin_password = local.kubernetes_cluster[each.key].windows_profile.admin_password
      license        = local.kubernetes_cluster[each.key].windows_profile.license

      dynamic "gmsa" {
        for_each = try(length(keys(local.kubernetes_cluster[each.key].windows_profile.gmsa)) > 0, false) ? [1] : []

        content {
          dns_server  = local.kubernetes_cluster[each.key].windows_profile.gmsa.dns_server
          root_domain = local.kubernetes_cluster[each.key].windows_profile.gmsa.root_domain
        }
      }
    }
  }

  tags = local.kubernetes_cluster[each.key].tags
}
