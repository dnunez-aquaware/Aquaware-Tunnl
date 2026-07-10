# Lab 04 — Scheduled Serverless Job con OpenTofu

## Descripción general

Este proyecto implementa un trabajo programado serverless utilizando OpenTofu como herramienta de Infrastructure as Code (IaC).

La infraestructura crea un **Amazon EventBridge Scheduler** que ejecuta periódicamente una función **AWS Lambda**. La función Lambda realiza una tarea simple de prueba y registra su ejecución en **Amazon CloudWatch Logs**.

Toda la infraestructura es creada y eliminada mediante código:

* Función Lambda
* Empaquetado del código Lambda
* Roles y políticas IAM
* CloudWatch Log Group
* EventBridge Scheduler

No se requiere configuración manual desde la consola de AWS.

---

# Arquitectura

```text
EventBridge Scheduler
        |
        | Asume Scheduler IAM Role
        |
        | lambda:InvokeFunction
        |
        v
AWS Lambda Function
        |
        | Asume Lambda Execution Role
        |
        | logs:PutLogEvents
        |
        v
CloudWatch Logs
```

---

# Componentes de la infraestructura

## 1. Función Lambda

Ubicación:

```text
lambda/handler.py
```

La función Lambda tiene una lógica mínima. Su objetivo es comprobar que el flujo de ejecución funciona correctamente.

La función:

* recibe la invocación del Scheduler;
* registra un mensaje con timestamp;
* finaliza correctamente.

La lógica de negocio no es importante en este laboratorio. El objetivo principal es demostrar la integración:

```text
EventBridge Scheduler → Lambda → CloudWatch Logs
```

---

# 2. Empaquetado de Lambda

OpenTofu genera automáticamente el paquete ZIP utilizando el data source:

```hcl
archive_file
```

No se crea ningún ZIP manualmente.

Flujo:

```text
handler.py
     |
     v
archive_file
     |
     v
lambda.zip
     |
     v
aws_lambda_function
```

El hash del paquete permite que OpenTofu detecte cambios en el código Lambda y actualice la función cuando sea necesario.

---

# 3. Lambda Execution Role

Este rol es utilizado por la función Lambda cuando se ejecuta.

La relación de confianza permite que:

```text
lambda.amazonaws.com
```

pueda asumir el rol.

Su objetivo es darle a Lambda únicamente los permisos necesarios para escribir logs.

Permisos permitidos:

```text
logs:CreateLogStream
logs:PutLogEvents
```

Estos permisos están limitados al Log Group propio de la función:

```text
/aws/lambda/<nombre-de-la-funcion>
```

No tiene permisos adicionales sobre otros servicios AWS.

Esto aplica el principio de **least privilege**.

---

# 4. Scheduler Invoke Role

Este rol es utilizado por EventBridge Scheduler.

La relación de confianza permite que:

```text
scheduler.amazonaws.com
```

pueda asumir el rol.

Su única responsabilidad es permitir que Scheduler invoque una Lambda específica.

Permiso:

```text
lambda:InvokeFunction
```

El recurso está limitado al ARN de una única Lambda:

```text
arn:aws:lambda:<region>:<account>:function:scheduled-job
```

No utiliza:

```text
Resource: "*"
```

porque eso permitiría invocar cualquier función Lambda de la cuenta.

---

# 5. CloudWatch Log Group

OpenTofu administra el destino donde Lambda escribe sus logs:

```text
/aws/lambda/scheduled-job
```

El Log Group se crea como código utilizando:

```hcl
aws_cloudwatch_log_group
```

Cada ejecución del Scheduler genera nuevos eventos de log.

Estos logs permiten comprobar que la cadena completa funciona.

---

# 6. EventBridge Scheduler

El recurso utilizado es:

```hcl
aws_scheduler_schedule
```

Ejemplo de programación:

```hcl
schedule_expression = "rate(5 minutes)"
```

El flujo de ejecución es:

```text
1. Scheduler espera el intervalo configurado.

2. Scheduler asume el Scheduler IAM Role.

3. Scheduler ejecuta lambda:InvokeFunction.

4. Lambda inicia la ejecución.

5. Lambda utiliza su Execution Role.

6. Lambda escribe logs en CloudWatch.
```

---

# Estructura del repositorio

```text
Day04/
├── lambda/
│   └── handler.py
│
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── .terraform.lock.hcl
│
└── env/
    └── backend.hcl
```

---

# Requisitos

Instalar:

* OpenTofu
* AWS CLI
* Credenciales AWS configuradas

Verificar OpenTofu:

```bash
tofu version
```

Verificar acceso AWS:

```bash
aws sts get-caller-identity
```

---

# Despliegue de infraestructura

Ingresar al directorio Terraform:

```bash
cd terraform
```

Inicializar OpenTofu:

```bash
AWS_PROFILE=<profile> tofu init \
-backend-config="../env/backend.hcl"
```

Formatear código:

```bash
tofu fmt -recursive
```

Validar configuración:

```bash
tofu validate
```

Revisar cambios:

```bash
AWS_PROFILE=<profile> tofu plan
```

Crear infraestructura:

```bash
AWS_PROFILE=<profile> tofu apply
```

---

# Validación del funcionamiento

Después del despliegue:

Ingresar a:

```text
AWS Console
 └── CloudWatch
      └── Log groups
```

Buscar:

```text
/aws/lambda/scheduled-job
```

Dentro del Log Group abrir el Log Stream más reciente.

Una ejecución correcta debe mostrar eventos similares:

```text
START RequestId

Scheduled job executed at <timestamp>

END RequestId

REPORT RequestId
```

Si aparecen nuevos eventos cada 5 minutos, significa que la integración funciona:

```text
EventBridge Scheduler
        ↓
Lambda Invocation
        ↓
Lambda Execution Role
        ↓
CloudWatch Logs
```

---

# Cambio del Schedule

Ejemplo inicial:

```hcl
schedule_expression = "rate(5 minutes)"
```

Cambio:

```hcl
schedule_expression = "rate(1 minute)"
```

Ejecutar:

```bash
tofu plan
```

OpenTofu debe mostrar una actualización en sitio:

```text
~ aws_scheduler_schedule.lambda_schedule
```

El recurso debe actualizarse y no destruirse/recrearse.

---

# Workflow CI/CD

El repositorio incluye un workflow de GitHub Actions ubicado en:

```text
.github/workflows/
```

El workflow se ejecuta cuando:

* existe un Pull Request hacia la rama `master`;
* existen cambios dentro de:

```text
Day04/**
```

Validaciones realizadas:

```text
tofu fmt -check
tofu validate
tofu plan
```

El objetivo es detectar errores de infraestructura antes de fusionar cambios.

---

# Eliminación de infraestructura

Para eliminar todos los recursos:

```bash
AWS_PROFILE=<profile> tofu destroy
```

OpenTofu eliminará:

* Lambda Function
* IAM Roles
* IAM Policies
* CloudWatch Log Group
* EventBridge Scheduler

La infraestructura completa puede ser creada y destruida nuevamente porque está definida completamente como código.
