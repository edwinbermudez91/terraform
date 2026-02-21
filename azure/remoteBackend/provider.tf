terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>4.8.0"
      }
    }
    required_version = ">=1.14.0"
    backend "azurerm" {
        resource_group_name   = "rg-terraform-state"
        storage_account_name  = "tfstate12254"
        container_name        = "tfstate"
        key                   = "test.terraform.tfstate"
      
    }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    resource_provider_registrations = "none"
}