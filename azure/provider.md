# Terraform Providers

## 🌍 ¿Qué es un proveedor (Provider) en Terraform?

Un proveedor (provider) en Terraform es un plugin que permite a Terraform interactuar con una plataforma o servicio externo para crear, modificar y eliminar recursos.

En otras palabras:

🔹 El provider es el puente entre Terraform y la API del servicio que quieres administrar.

## 🔧 ¿Qué hace un Provider?

Un provider le dice a Terraform:

- Cómo autenticarse en el servicio
- Cómo comunicarse con su API
- Qué recursos están disponibles
- Cómo gestionarlos (crear, leer, actualizar, eliminar)

Sin un provider, Terraform no sabría cómo interactuar con ningún sistema externo.

## ☁️ Ejemplos de Providers Populares

- Azure Provider

```
provider "azurerm" {
  features {}
}
```

- Kubernetes

```
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

- AWS

```
provider "aws" {
  region = "us-east-1"
}
```

## 🔎 Provider Version vs Terraform Core Version

En Terraform existen dos tipos de versiones completamente diferentes, y es clave no confundirlas:

| Concepto                   | Qué es                                                       | Qué controla                                                          |
| -------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------- |
| **Terraform Core Version** | La versión del binario `terraform`                           | Cómo funciona Terraform (plan, apply, state, sintaxis HCL, etc.)      |
| **Provider Version**       | La versión del plugin del provider (aws, azurerm, k8s, etc.) | Cómo se comunican y qué recursos están disponibles en cada plataforma |



```
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0.2"
        }
    }

    required_version = ">= 1.1.0"
}

provider "azurerm" {
    features {}
}
```

## Version constraints and operators

1️⃣ = (Exacto)

```
version = "= 3.100.0"
```

- ✔ Solo acepta exactamente esa versión
- ❌ No permite ni 3.100.1

2️⃣ != (Excluir versión)

```
version = "!= 3.101.0"
```

- ✔ Permite cualquier versión excepto esa.

3️⃣ > (Mayor que)

```hcl
version = "> 3.90.0"
```

- ✔ Acepta 3.91, 3.100, 4.0…
- ⚠ Puede romper si sale una versión mayor incompatible.

4️⃣ >= (Mayor o igual)

```hcl
version = ">= 3.95.0"
```

- ✔ Permite cualquier versión superior
- ⚠ Riesgoso sin límite superior.


5️⃣ < y <=

```hcl
version = "< 4.0.0"
```

- Muy útil para evitar upgrades mayores.

🚀 6️⃣ Operador MÁS IMPORTANTE: ~> (Pessimistic Constraint)

Este es el estándar en proyectos enterprise Azure.

**🔹 Caso 1:**

```
version = "~> 3.100"
```

Significa:

```
>= 3.100.0
< 3.101.0
```

- ✔ Permite parches
- ❌ No permite subir minor version

**🔹 Caso 2:**

```
version = "~> 3.0"
```

Significa:

```
>= 3.0.0
< 4.0.0
```
- ✔ Permite todas las versiones 3.x
- ❌ No permite 4.0

**🔹 Caso 3:**
```
version = "~> 3"
```

Significa:
```
>= 3.0.0
< 4.0.0
```

(igual que el anterior)

## 🏢 Buenas prácticas en Azure Enterprise

🔵 Para Terraform Core

```
required_version = "~> 1.7.0"
```

🔵 Para Azure Provider

```
version = "~> 3.100"
```

Esto permite:

- Fixes
- Security patches
- Sin romper con 4.x


## 🔐Crear Service Principal en Azure

1️⃣ Login en Azure

```bash
az login
```

Si trabajas en múltiples suscripciones:

```bash
az account set --subscription "SUBSCRIPTION_ID"
```

Verificar:

```bash
az account show --output table
```

2️⃣ Crear Service Principal

```bash
az ad sp create-for-rbac \
  -n  az-demo \
  --role="Contributor" \ 
  --scopes="/subscriptions/xxxxxx"
```

📌 Output esperado


```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx",
  "displayName": "az-demo",
  "password": "xxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"
}
```

Guardar estos valores

| Campo    | Uso           |
| -------- | ------------- |
| appId    | client_id     |
| password | client_secret |
| tenant   | tenant_id     |

🎯 Uso típico en Terraform

```bash
export ARM_CLIENT_ID="appId"
export ARM_CLIENT_SECRET="password"
export ARM_SUBSCRIPTION_ID="subscription_id"
export ARM_TENANT_ID="tenant"
```

### 🔐 Buenas prácticas (muy importante)

- ❌ No usar Contributor a nivel suscripción en producción
- ✔ Mejor usar rol mínimo necesario
- ✔ Usar Managed Identity si es posible
- ✔ Evitar credenciales estáticas en pipelines
- ✔ Considerar Workload Identity Federation (OIDC)

### 🔎 Alternativa más segura (recomendada hoy)

En vez de usar client secret:

```bash
az ad sp create-for-rbac \
  --name az-demo \
  --role Contributor \
  --scopes /subscriptions/xxxxxx \
  --sdk-auth
```

O mejor aún:

- GitHub → OIDC federation
- Azure DevOps → Federated Credentials
- AKS → Workload Identity

