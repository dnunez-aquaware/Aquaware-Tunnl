# Comparación OPA / Conftest vs HashiCorp Sentinel

## Introducción

Ambas herramientas implementan el concepto de **Policy as Code**, donde las reglas de seguridad, cumplimiento y gobernanza se escriben como código y se ejecutan automáticamente antes de realizar cambios en infraestructura.

El objetivo es evitar configuraciones inseguras antes de llegar a producción.

Ejemplos de reglas:

* No permitir recursos públicos.
* Exigir etiquetas obligatorias.
* Restringir regiones.
* Cumplir estándares corporativos.

---

# ¿Qué es OPA?

## Open Policy Agent (OPA)

OPA es un motor de políticas de propósito general basado en el lenguaje **Rego**.

Puede utilizarse con:

* Terraform.
* Kubernetes.
* APIs.
* CI/CD.
* Microservicios.
* Sistemas de autorización.

En este laboratorio se utiliza mediante **Conftest** para analizar el resultado de Terraform Plan.

Flujo:

```
Terraform Plan
```

↓

```
Terraform Show JSON
```

↓

```
Conftest
```

↓

```
OPA/Rego
```

↓

```
PASS / FAIL
```

---

# ¿Qué es Sentinel?

Sentinel es la solución de Policy as Code desarrollada por HashiCorp.

Está integrada principalmente con:

* Terraform Cloud.
* Terraform Enterprise.

Permite controlar ejecuciones Terraform mediante políticas centralizadas.

Flujo:

```
Terraform Cloud
```

↓

```
Terraform Plan
```

↓

```
Sentinel Policies
```

↓

```
PASS / FAIL
```

---

# Comparación general

| Característica            | OPA / Conftest        | Sentinel                              |
| ------------------------- | --------------------- | ------------------------------------- |
| Tipo                      | Open Source           | Producto HashiCorp                    |
| Lenguaje                  | Rego                  | Sentinel                              |
| Licencia                  | Gratuita              | Asociada a Terraform Enterprise/Cloud |
| Integración               | Muy amplia            | Ecosistema HashiCorp                  |
| Dependencia del proveedor | Baja                  | Alta                                  |
| CI/CD                     | Excelente integración | Principalmente Terraform Cloud        |
| Kubernetes                | Sí                    | No es su objetivo principal           |
| Terraform                 | Sí                    | Sí                                    |
| Flexibilidad              | Muy alta              | Media                                 |
| Curva inicial             | Media                 | Media                                 |

---

# Costos

## OPA / Conftest

Ventajas:

* Sin costo de licencia.
* Código abierto.
* Puede ejecutarse en cualquier pipeline CI/CD.

Desventaja:

* La organización debe construir la integración.

---

## Sentinel

Ventajas:

* Incluido dentro de Terraform Cloud Enterprise.
* Administración centralizada.

Desventaja:

* Puede requerir licenciamiento HashiCorp.

---

# Seguridad

## OPA

Ventajas:

* Permite implementar controles independientes.
* Puede integrarse con múltiples herramientas.

Ejemplos:

* Seguridad cloud.
* Kubernetes admission control.
* Validaciones CI/CD.

## Sentinel

Ventajas:

* Control centralizado dentro del ecosistema Terraform.
* Integración con permisos Terraform Cloud.

---

# Escalabilidad

## OPA

Escala bien en ambientes con múltiples tecnologías:

* AWS.
* Azure.
* Kubernetes.
* APIs.
* CI/CD.

## Sentinel

Escala bien dentro de organizaciones que utilizan Terraform Cloud Enterprise.

---

# Developer Experience

## OPA

Ventajas:

* Fácil integración con GitHub Actions.
* Permite validaciones locales.

Ejemplo:

```
conftest test tfplan.json
```

## Sentinel

Ventajas:

* Integración automática con Terraform Cloud.

Desventaja:

* Menor facilidad fuera del ecosistema HashiCorp.

---

# Casos recomendados

## Usar OPA / Conftest cuando:

* Existe una plataforma CI/CD propia.
* Se usan múltiples tecnologías.
* Se busca evitar dependencia de proveedores.
* Se quiere una solución open source.

## Usar Sentinel cuando:

* La empresa usa Terraform Cloud Enterprise.
* Se necesita gobernanza centralizada dentro de HashiCorp.
* Terraform es la plataforma principal.

---

# Políticas implementadas en este laboratorio

Ambas herramientas implementan:

## Restricción de regiones

Solo permite regiones AWS aprobadas.

---

## Control de S3 público

Bloquea buckets con exposición pública.

---

## Tags obligatorios

Exige:

* Owner.
* Environment.
* Project.

---

# Conclusión

OPA/Conftest es una alternativa más flexible y portable para implementar Policy as Code.

Sentinel es una solución potente cuando la organización ya está comprometida con Terraform Cloud o Terraform Enterprise.

Para una estrategia moderna basada en CI/CD abierto, la recomendación es:

**GitHub Actions + OPA/Conftest**
