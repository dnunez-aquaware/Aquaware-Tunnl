# Comparación Atlantis vs GitHub Actions

## Introducción

Atlantis y GitHub Actions permiten automatizar workflows relacionados con Terraform, pero tienen objetivos diferentes.

GitHub Actions es una plataforma general de CI/CD.

Atlantis está especializado en flujos Terraform basados en Pull Requests.

---

# GitHub Actions

GitHub Actions permite crear pipelines personalizados mediante archivos YAML.

Ubicación:

```
.github/workflows/
```

En este proyecto:

```
.github/workflows/gha-tfplan.yaml
```

---

# Flujo GitHub Actions

```
Developer
```

↓

```
Pull Request
```

↓

```
GitHub Actions
```

↓

```
terraform fmt
```

↓

```
terraform validate
```

↓

```
terraform plan
```

↓

```
OPA Validation
```

↓

```
Approval
```

↓

```
terraform apply
```

---

# Atlantis

Atlantis es una herramienta diseñada específicamente para Terraform.

Trabaja mediante Pull Requests.

El archivo de configuración:

```
code/CICD/atlantis.yaml
```

define:

* Proyectos Terraform.
* Directorios.
* Workflows.
* Reglas de aprobación.

---

# Flujo Atlantis

```
Developer
```

↓

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

# Comparación

| Característica     | GitHub Actions    | Atlantis                         |
| ------------------ | ----------------- | -------------------------------- |
| Objetivo principal | CI/CD general     | Terraform workflow               |
| Terraform          | Soportado         | Especializado                    |
| Flexibilidad       | Muy alta          | Media                            |
| Lenguaje           | YAML              | YAML                             |
| Integración GitHub | Nativa            | Mediante integración             |
| OPA                | Fácil integración | Requiere configuración adicional |
| Docker             | Sí                | No es objetivo principal         |
| Testing            | Sí                | Limitado                         |
| Escalabilidad      | Alta              | Alta para Terraform              |
| Instalación        | Servicio GitHub   | Servidor propio                  |

---

# Costos

## GitHub Actions

Ventajas:

* Incluido con GitHub.
* Gran ecosistema.
* No requiere infraestructura adicional.

Desventajas:

* Límites según plan GitHub.

## Atlantis

Ventajas:

* Open Source.
* Control propio del servicio.

Desventajas:

* Requiere operar un servidor.
* Requiere mantenimiento.

---

# Seguridad

## GitHub Actions

Permite integrar:

* OIDC con AWS.
* Secret Management.
* Scanners.
* Policy engines.

## Atlantis

Ventajas:

* Control centralizado Terraform.
* Integración con permisos del repositorio.

Desventaja:

* Debe asegurarse el servidor Atlantis.

---

# Developer Experience

## GitHub Actions

Ventajas:

* Familiar para equipos DevOps.
* Permite cualquier automatización.

Desventajas:

* El pipeline debe diseñarse.

## Atlantis

Ventajas:

* Excelente experiencia Terraform.

Ejemplo:

Comentario en PR:

```
atlantis plan
```

Luego:

```
atlantis apply
```

---

# Escenarios recomendados

## Usar GitHub Actions cuando:

* Existe una plataforma DevOps completa.
* Se necesitan múltiples herramientas.
* Hay procesos además de Terraform.

Ejemplo:

Terraform + Docker + Seguridad + Testing.

---

## Usar Atlantis cuando:

* Terraform es la herramienta principal.
* El equipo trabaja con muchos Pull Requests de infraestructura.
* Se desea visualizar planes directamente en GitHub.

---

# Comparación de arquitectura

## GitHub Actions

```
GitHub

   |

   v

Workflow YAML

   |

   v

Terraform
```

---

## Atlantis

```
GitHub PR

   |

   v

Atlantis Server

   |

   v

Terraform
```

---

# Conclusión

GitHub Actions ofrece una plataforma más completa y flexible para automatización DevOps.

Atlantis es una herramienta especializada que mejora el flujo colaborativo de Terraform mediante Pull Requests.

La recomendación para este laboratorio es:

**GitHub Actions + OPA/Conftest como solución inicial.**

Atlantis puede evaluarse posteriormente cuando Terraform sea el centro principal de operación de infraestructura.
