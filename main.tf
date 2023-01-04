/**
* # container
*
* This module manages the azurerm container resources.
* For more information see https://registry.terraform.io/providers/azurerm/latest/docs > container
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

  /** policy can only be applied when using the Premium sku */
  dynamic "network_rule_set" {
    for_each = local.container_registry[each.key].sku == "Premium" ? [1] : []

    content {
      default_action = local.container_registry[each.key].network_rule_set.default_action

      dynamic "ip_rule" {
        for_each = local.container_registry[each.key].network_rule_set.ip_rule
        content {
          action   = local.container_registry[each.key].network_rule_set.ip_rule[ip_rule.key].action
          ip_range = local.container_registry[each.key].network_rule_set.ip_rule[ip_rule.key].ip_range
        }
      }

      dynamic "virtual_network" {
        for_each = local.container_registry[each.key].network_rule_set.virtual_network
        content {
          action    = local.container_registry[each.key].network_rule_set.virtual_network[virtual_network.key].action
          subnet_id = local.container_registry[each.key].network_rule_set.virtual_network[virtual_network.key].subnet_id
        }
      }
    }
  }

  /** policy can only be applied when using the Premium sku */
  dynamic "retention_policy" {
    for_each = local.container_registry[each.key].sku == "Premium" ? [1] : []

    content {
      days    = local.container_registry[each.key].retention_policy.days
      enabled = local.container_registry[each.key].retention_policy.enabled
    }
  }

  /** policy can only be applied when using the Premium sku */
  dynamic "trust_policy" {
    for_each = local.container_registry[each.key].sku == "Premium" ? [1] : []

    content {
      enabled = local.container_registry[each.key].trust_policy.enabled
    }
  }

  dynamic "identity" {
    for_each = local.container_registry[each.key].identity.type != null ? [1] : []

    content {
      type         = local.container_registry[each.key].identity.type
      identity_ids = local.container_registry[each.key].identity.identity_ids
    }
  }

  dynamic "encryption" {
    for_each = compact([
      local.container_registry[each.key].encryption.key_vault_key_id,
      local.container_registry[each.key].encryption.identity_client_id
    ])

    content {
      enabled            = local.container_registry[each.key].encryption.enabled
      key_vault_key_id   = local.container_registry[each.key].encryption.key_vault_key_id
      identity_client_id = local.container_registry[each.key].encryption.identity_client_id
    }
  }

  tags = local.container_registry[each.key].tags
}
