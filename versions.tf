terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = ">=3.40.0"
    }
  }
  required_version = ">=1.3"
}
