# 📦 Variables en Terraform

Las variables en Terraform permiten parametrizar tu infraestructura para que el mismo código funcione en distintos ambientes (dev, qa, prod) sin modificar los archivos principales.

## 🎯 ¿Para qué sirven?

- Reutilizar código
- Separar configuración de lógica
- Evitar valores hardcodeados
- Facilitar despliegues multi-ambiente
- Mejorar seguridad (no dejar secrets en el código)

## 🧩 Tipos de Variables en Terraform

Terraform maneja principalmente:

- Input Variables → Las más comunes (variable)
- Local Variables → Variables internas (locals)
- Output Variables → Valores que Terraform devuelve (output)

### 1️⃣ Input Variables (las más usadas)

Se definen en variables.tf

```hcl
variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
```

Se usan así:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = var.location
}
```

👉 Se llaman con `var.nombre_variable`


**🔎 Tipos de datos soportados**


| Tipo         | Ejemplo                           |
| ------------ | --------------------------------- |
| string       | `"eastus"`                        |
| number       | `3`                               |
| bool         | `true`                            |
| list(string) | `["eastus", "westus"]`            |
| map(string)  | `{ env = "dev" }`                 |
| object       | `{ name = string, age = number }` |


Ejemplo complejo:

```hcl
variable "tags" {
  type = map(string)
}
```

Uso:
```hcl
tags = var.tags
```

### 2️⃣ Cómo asignar valores

Terraform puede recibir variables desde:

**📁 1. terraform.tfvars**

```hcl
location = "East US"
```

**🖥️ 2. CLI**

```bash
terraform apply -var="location=West US"
```

**📦 3. Archivo personalizado**

```bash
terraform apply -var-file="prod.tfvars"
```


**🌎 4. Variables de entorno**

```bash
export TF_VAR_location="East US"
```



### 3️⃣ Variables Locales (locals)

Se usan para cálculos internos o valores derivados.

```hcl
locals {
  resource_prefix = "rg-${var.environment}"
}
```

uso:

```hcl
name = local.resource_prefix
```

Se llaman con `local.nombre`

### 4️⃣ Output Variables

Permiten mostrar información después del apply.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
```

Salida:

```bash
Outputs:
resource_group_name = "rg-demo"
```

**🔐 Variables Sensibles**

Para proteger secretos:

```hcl
variable "client_secret" {
  type      = string
  sensitive = true
}
```

Terraform ocultará el valor en el output.



## 🏗️ Ejemplo completo (Azure)

```hcl
variable "environment" {
  type = string
}

variable "location" {
  type = string
}

locals {
  rg_name = "rg-${var.environment}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}
```

**📌 Flujo típico en proyectos reales**

```bash
variables.tf
dev.tfvars
prod.tfvars
main.tf
outputs.tf
```

Ejecutar:

```bash
terraform apply -var-file="dev.tfvars"
```

## 🏢 Buenas prácticas (nivel DevOps / Enterprise)

- ✔ Definir siempre `type`
- ✔ Usar `description`
- ✔ Separar `variables.tf`
- ✔ Usar `tfvars` por ambiente
- ✔ No subir secrets al repo
- ✔ Usar Azure Key Vault o variables del pipeline para secretos