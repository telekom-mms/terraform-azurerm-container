terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "< 5.7"
    }
  }
  required_version = ">=1.5"
}
