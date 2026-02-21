terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"
    storage_account_name  = "tfstate12254"
    container_name        = "tfstate"
    key                   = "test.terraform.tfstate"
  }
}