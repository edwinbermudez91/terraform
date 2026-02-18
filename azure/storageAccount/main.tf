terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>4.8.0"
      }
    }
    required_version = ">=1.14.0"
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "test" {
  name     = "rg-test"
  location = "West US"
}

resource "azurerm_storage_account" "sa" {
  name                     = "satest"
  resource_group_name      = azurerm_resource_group.test.name       #Implicit dependecy
  location                 = azurerm_resource_group.test.location   #Implicit dependecy
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
    owner       = "ehbc"
  }
}