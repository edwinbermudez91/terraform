# Remote Backend de Terraform en Azure

Un remote backend en Terraform permite guardar el estado (terraform.tfstate) de forma centralizada, evitando conflictos cuando trabajas en equipo y permitiendo bloqueos para evitar ejecuciones simultáneas.

En Azure, el backend más común es Azure Storage Account + Blob Storage.

Componentes necesarios:

- Resource Group
- Storage Account
- Blob Container
- Service Principal o Managed Identity para autenticación

## 🚀 Paso a Paso

```bash

1️⃣ Crear recursos en Azure

# Variables
RG_NAME="rg-terraform-state"
LOCATION="westus"
STORAGE_NAME="tfstate$RANDOM"
CONTAINER_NAME="tfstate"

# Crear Resource Group
az group create --name $RG_NAME --location $LOCATION

# Crear Storage Account
az storage account create \
  --name $STORAGE_NAME \
  --resource-group $RG_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# Crear Container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_NAME

```

2️⃣ Configurar el backend en Terraform

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "NOMBRE_STORAGE"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```
⚠️ Reemplaza NOMBRE_STORAGE por el nombre real del storage account.

3️⃣ Inicializar Terraform

```bash
terraform init
```

Si ya tenías estado local:

```bash
terraform init -migrate-state
```

