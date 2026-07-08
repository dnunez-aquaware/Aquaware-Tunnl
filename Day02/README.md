# Day02 - Terraform Workflow & Policy as Code Comparison

## Objetivo

Este proyecto implementa una comparación práctica entre herramientas de **Policy as Code** y herramientas de automatización CI/CD para Terraform.

Las tecnologías evaluadas son:

* OPA / Conftest
* HashiCorp Sentinel
* GitHub Actions
* Atlantis

El objetivo es demostrar cómo aplicar controles automáticos sobre infraestructura como código antes de realizar despliegues en AWS.

---

# Arquitectura general

El flujo del proyecto es:

Developer

↓

Git Repository

↓

Terraform Plan

↓

Policy Validation

↓

Approval

↓

Terraform Apply

Las validaciones pueden ejecutarse mediante:

* GitHub Actions + OPA/Conftest.
* Atlantis para flujos basados en Pull Requests.

---

# Estructura del proyecto

```
Day02/
|
├── code/
│   |
│   ├── stack/
│   │   └── terraform/
│   │       ├── main.tf
│   │       ├── providers.tf
│   │       └── outputs.tf
│   |
│   ├── policies/
│   │   ├── opa/
│   │   │   ├── allowed_regions.rego
│   │   │   ├── deny_public_s3.rego
│   │   │   └── required_tags.rego
│   │   |
│   │   └── sentinel/
│   │       ├── allowed_regions.sentinel
│   │       ├── deny_public_s3.sentinel
│   │       └── required_tags.sentinel
│   |
│   └── CICD/
│       └── atlantis.yaml
|
├── docs/
|
└── README.md
```

El workflow de GitHub Actions se encuentra a nivel del repositorio:

```
.github/workflows/gha-tfplan.yaml
```

Esto es necesario porque GitHub solamente reconoce workflows dentro de `.github/workflows`.

---

# Terraform Demo

La infraestructura de ejemplo utiliza AWS S3.

Se incluyen escenarios:

## Recurso conforme

El bucket cumple las reglas:

* Tiene cifrado.
* Tiene tags obligatorios.
* No permite acceso público.
* Utiliza una región permitida.

## Recurso no conforme

Existe un ejemplo intencionalmente incorrecto para demostrar la validación:

* Falta de tags.
* Configuración insegura.
* Región no autorizada.

El objetivo es demostrar que las políticas pueden detener cambios incorrectos antes del despliegue.

---

# OPA / Conftest

OPA permite implementar reglas de cumplimiento como código.

El flujo es:

```
terraform plan
```

↓

```
terraform show -json
```

↓

```
conftest test
```

↓

```
OPA Policies
```

↓

```
PASS / FAIL
```

Las políticas implementadas son:

## allowed_regions.rego

Valida que los recursos sean desplegados solamente en regiones permitidas.

---

## deny_public_s3.rego

Bloquea configuraciones donde un bucket S3 pueda quedar expuesto públicamente.

---

## required_tags.rego

Verifica que los recursos tengan los tags corporativos requeridos:

* Owner
* Environment
* Project

---

# Sentinel

Sentinel es la solución Policy as Code de HashiCorp.

Implementa reglas equivalentes a OPA:

* Restricción de regiones.
* Validación de tags.
* Bloqueo de buckets públicos.

La diferencia principal es que Sentinel está integrado principalmente con:

* Terraform Cloud.
* Terraform Enterprise.

---

# GitHub Actions

El workflow ubicado en:

```
.github/workflows/gha-tfplan.yaml
```

implementa:

1. terraform fmt.
2. terraform validate.
3. terraform plan en Pull Requests.
4. Conversión del plan a JSON.
5. Validación con OPA/Conftest.
6. Terraform apply después del merge.
7. Aprobación manual mediante GitHub Environment.

---

# Atlantis

Atlantis utiliza el archivo:

```
code/CICD/atlantis.yaml
```

para definir proyectos Terraform y automatización basada en Pull Requests.

Flujo:

```
Pull Request
```

↓

```
Atlantis detecta cambios
```

↓

```
terraform plan
```

↓

```
Resultado publicado en PR
```

↓

```
atlantis apply
```

↓

```
terraform apply
```

---

# Comparaciones

Las comparaciones completas están disponibles en:

* docs/opa-vs-sentinel.md
* docs/atlantis-vs-github-actions.md

---

# Conclusión

La recomendación final del laboratorio es:

GitHub Actions + OPA/Conftest

porque ofrece:

* Flexibilidad.
* Integración con múltiples herramientas.
* Bajo costo.
* Independencia del proveedor.

Atlantis es recomendable cuando Terraform es el núcleo principal del flujo operativo.

Sentinel es recomendable cuando la organización utiliza Terraform Cloud o Terraform Enterprise.
