terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "< 5.13"
    }
  }
  required_version = ">=1.5"
}
