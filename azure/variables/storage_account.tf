resource "azurerm_storage_account" "sa" {
  name                     = var.name_storage_account
  resource_group_name      = azurerm_resource_group.test.name       #Implicit dependecy
  location                 = azurerm_resource_group.test.location   #Implicit dependecy
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags  = local.common_tags
}