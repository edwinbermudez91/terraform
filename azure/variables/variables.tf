variable "subscription_id" {
    type = string
    description = "Azure Suscribtion ID"
}

variable "name_rg" {
  type = string
  description = "Nombre del grupo de recursos"
}

variable "location" {
  type        = string
  description = "Ubicación del grupo de recursos"
  default     = "West US"
}

variable "environment" {
  type   = string
  description = "Ambiente de despliegue"
}

variable "name_storage_account" {
  type = string
  description = "Nombre de la cuenta de almacenamiento"
}

variable "account_replication_type" {
  type = string
  description = "Tipo de replicación de la cuenta de almacenamiento"
}

variable "account_tier" {
  type = string
  description = "Tipo de cuenta de almacenamiento"
}