variable "container_registry" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    /** resource definition */
    container_registry = {
      name                          = ""
      sku                           = "Basic"
      admin_enabled                 = false
      public_network_access_enabled = null
      quarantine_policy_enabled     = null
      zone_redundancy_enabled       = null
      export_policy_enabled         = null
      network_rule_bypass_option    = "None" /** disallows default AzureServices as enabled for access */
      anonymous_pull_enabled        = null
      data_endpoint_enabled         = null
      network_rule_set = {
        default_action = "Deny"
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
        regional_endpoint_enabled = false
        zone_redundancy_enabled   = false
        tags                      = {}
      }
      tags = {}
    }
  }

  /** compare and merge custom and default values */
  container_registry_values = {
    for container_registry in keys(var.container_registry) :
    container_registry => merge(local.default.container_registry, var.container_registry[container_registry])
  }

  /** deep merge of all custom and default values */
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
              key => keys(local.container_registry_values[container_registry][config][subconfig]) == keys(local.default.container_registry[config][subconfig]) ? {} : merge(local.default.container_registry[config][subconfig], local.container_registry_values[container_registry].network_rule_set.ip_rule[key])
            }
          }
        )
      }
    )
  }
}
