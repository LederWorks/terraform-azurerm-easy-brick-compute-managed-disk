################################ Providers
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

################################ Terraform
terraform {
  required_version = ">=1.3.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rgrp-pde3-it-terratest"
    storage_account_name = "saccpde3itterratest001"
    container_name       = "terratest-azurerm"
    key                  = "terratest-azurerm-easy-brick-compute-disk"
    snapshot             = true
  }
}

################################ Client Config Current
data "azurerm_client_config" "current" {
}