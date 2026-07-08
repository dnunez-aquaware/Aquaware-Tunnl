# Documentación técnica del código

## Introducción

La carpeta `code` contiene todos los componentes técnicos del laboratorio:

* Terraform.
* Políticas OPA.
* Políticas Sentinel.
* Configuración Atlantis.

---

# Terraform

Ubicación:

```
code/stack/terraform/
```

Archivos:

* providers.tf
* main.tf
* outputs.tf

---

# providers.tf

Este archivo define la configuración del proveedor AWS.

Responsabilidades:

* Definir la versión del proveedor.
* Configurar la región AWS.
* Preparar Terraform para comunicarse con AWS.

---

# main.tf

Este archivo contiene los recursos AWS.

Para este laboratorio se utiliza S3 porque permite demostrar fácilmente controles de seguridad.

Ejemplo de validaciones:

* Tags obligatorios.
* Bloqueo de acceso público.
* Cifrado.
* Región permitida.

---

# outputs.tf

Define valores que Terraform mostrará después del despliegue.

Ejemplos:

* Nombre del bucket.
* ARN del bucket.
* Identificadores necesarios para otras herramientas.

---

# Políticas OPA

Ubicación:

```
code/policies/opa/
```

OPA utiliza lenguaje Rego.

Las políticas analizan el resultado de:

```
terraform plan
```

convertido a formato JSON.

---

# allowed_regions.rego

Objetivo:

Controlar que Terraform solamente utilice regiones autorizadas.

Ejemplo:

Permitido:

```
us-east-1
```

Bloqueado:

```
regiones no aprobadas por la organización.
```

---

# deny_public_s3.rego

Objetivo:

Evitar exposición pública de buckets S3.

La política revisa configuraciones relacionadas con:

* Public Access Block.
* Políticas públicas.
* ACL públicas.

---

# required_tags.rego

Objetivo:

Aplicar gobernanza mediante etiquetas.

Tags obligatorios:

* Owner.
* Environment.
* Project.

Esto permite:

* Cost allocation.
* Ownership.
* Auditoría.
* Gestión empresarial.

---

# Políticas Sentinel

Ubicación:

```
code/policies/sentinel/
```

Sentinel implementa las mismas reglas utilizando el lenguaje de HashiCorp.

Políticas:

## allowed_regions.sentinel

Restringe regiones AWS.

## deny_public_s3.sentinel

Bloquea buckets públicos.

## required_tags.sentinel

Valida tags obligatorios.

---

# GitHub Actions

Ubicación:

```
.github/workflows/gha-tfplan.yaml
```

Responsabilidades:

## terraform fmt

Verifica formato correcto del código Terraform.

## terraform validate

Comprueba errores sintácticos y de configuración.

## terraform plan

Genera la propuesta de cambios.

## OPA Validation

Ejecuta Conftest contra el plan JSON.

## Apply

Después del merge y aprobación manual ejecuta:

```
terraform apply
```

---

# Atlantis

Ubicación:

```
code/CICD/atlantis.yaml
```

Atlantis automatiza Terraform mediante Pull Requests.

Funciones:

* Ejecutar plan automáticamente.
* Mostrar resultados en PR.
* Controlar apply mediante aprobación.

---

# Flujo completo

```
Developer
```

↓

```
Pull Request
```

↓

```
GitHub Actions / Atlantis
```

↓

```
Terraform Plan
```

↓

```
Policy Validation
```

↓

```
Approval
```

↓

```
Terraform Apply
```

---

# Objetivo final

El proyecto demuestra cómo aplicar controles de seguridad y gobernanza antes de desplegar infraestructura mediante Terraform.
