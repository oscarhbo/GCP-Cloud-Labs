# Laboratorio 6: Despliegue de una Aplicación web en Python con App Engine

Bienvenido al laboratorio "Despliegue de una Aplicación web en Python con App Engine". En este laboratorio, aprenderás a desplegar una aplicación web escrita en Python utilizando Google App Engine en Google Cloud Platform (GCP). App Engine es un servicio completamente administrado que te permite implementar aplicaciones web y escalar automáticamente según la demanda de tráfico, sin tener que preocuparte por la administración de un servidor.

En este laboratorio, desplegaremos una aplicación web simple. Utilizaremos el framework Flask para crear nuestra aplicación web en Python.

App Engine nos permite enfocarnos en el desarrollo de nuestra aplicación sin preocuparnos por la infraestructura subyacente. Además, App Engine escala automáticamente nuestra aplicación en función del tráfico entrante, lo que garantiza que nuestra aplicación sea altamente disponible y pueda manejar cualquier carga de trabajo.

---


<p align="center">
  <img src="./imagenes/diagrama.png" alt="diagrama" width="50%" height="50%">
</p>


## Antes de comenzar
Antes de comenzar este laboratorio, es necesario que tengas una cuenta en GCP y conozcas los conceptos básicos de la plataforma.

## Objetivo
En este lab, aprenderás cómo desplegar una aplicación de Python en APP Engine, adicional también podrás aprender como probar la aplicación antes de ser desplegada desde el SDK de GCP.
  

## Instrucciones

---
### Modalidad Paso a Paso

Ejecutar de forma manual cada una de las instrucciones, lo que permite visualizar y explorar el avance desde la consola. Para ello ejecuta los siguientes pasos:


### Nota importante:

Debido a que una vez que se despliega una app en App Engine, no puede ser eliminada, se recomienda realizar la creación de un nuevo proyecto sobre el cual se desplegara el App de ejemplo de este laboratorio. 

### Habilitar la API de Google App Engine

Para habilitar el API de App Engine desde consola se deben de realizar los siguientes pasos:

1. En el menú de navegación de la izquierda, haz clic en APIs y servicios > Biblioteca.

2. Escribe "API de App Engine Admin" en el cuadro de búsqueda.

3. Haz clic en la tarjeta API de App Engine Admin.

4. Haz clic en Habilitar. Si no hay ninguna solicitud para habilitarla, significa que ya está habilitada y no deberás hacer nada.

O se puede habilitar desde el Cloud Shell con la siguiente instrucción :

`gcloud services enable appengine.googleapis.com --project=$GOOGLE_CLOUD_PROJECT`


### Descargar la app en python de ejemplo


1. Descarga la app de ejemplo con la siguiente instrucción

`git clone https://github.com/oscarhbo/GCP-Cloud-Labs.git`

2. Ir al directorio del código muestra 

`cd GCP-Cloud-Labs/Lab6_AppEngine/Hola_Mundo`

### Probar la Aplicación antes de Desplegar

Usaremos la utilidad dev_appserver.py incluida con el SDK de GCP, la cual nos sirve para probar de manera local simulando el entorno de App engine

1. ejecutar el siguiente comando 

  `dev_appserver.py app.yaml`

2. Para ver los resultados, hacer click en el icono de Web preview > Preview on port 8080.



### Desplegar la App

1. Con control-c parar la ejecución del dev_appserver 

2. Para desplegar la App hay que ir al directorio en donde esté la app con el archivo app.yaml 

`cd GCP-Cloud-Labs/Lab6_AppEngine/Hola_Mundo` 

3. Y ejecutar la siguiente instrucción:

`gcloud app deploy`

4. seleccionar la región en donde se desplegará la App, escogiendo un número de las regiones listadas

5. Para visualizar la aplicación ejecutar el comando

`gcloud app browse`

6. Si no se despliega la App dar click en el link que arroja en la consola


### Hacer un Cambio en la App 

1. ir al directorio en donde esté la el archivo main.py

`cd GCP-Cloud-Labs/Lab6_AppEngine/Hola_Mundo` 

2. editar el archivo y cambiar el mensaje de la app:

`nano main.py`

3. Desplegar nuevamente la aplicación

`gcloud app deploy`

4. Confirmar con un Y que si queremos desplegar nuevamente la App


5. Para visualizar la aplicación ejecutar el comando

`gcloud app browse`

6. Si no se despliega la App dar click en el link que arroja en la consola


Ahora podemos ver que se debe de haber desplegado la nueva versión de la App con los cambios realizados.


## ***¡Felicidades!***

Ahora ya has entendido como probar una Web App desde el SDK de GCP y la facilidad para desplegar esa misma app desde Google App Engine.


## Archivos
Este laboratorio incluye los siguientes archivos:
- `app.yaml`: Archivo de configuración principal de Google App Engine. Define cómo se ejecutará y se comportará tu aplicación. Puedes especificar cosas como el lenguaje de programación, la versión del entorno, los recursos, las URL, entre otras configuraciones.

- `requirements.txt`: Este archivo es típicamente utilizado en aplicaciones de Python para especificar las dependencias (bibliotecas y paquetes) que tu aplicación necesita para funcionar correctamente. Las dependencias enumeradas en este archivo se instalarán automáticamente cuando despliegues tu aplicación en App Engine.

- `main.py`: Este archivo es utilizado en aplicaciones de Python para App Engine. Su función principal es actuar como el punto de entrada principal de tu aplicación y gestionar las solicitudes HTTP entrantes.

---

## Ayuda de Comandos utilizados

 - `dev_appserver.py app.yaml`: Este comando se utiliza para ejecutar una aplicación en el servidor de desarrollo local.


- `app.yaml` es el archivo de configuración de la aplicación.



- `gcloud app deploy`: Este comando se utiliza para implementar una aplicación en Google App Engine.

El comando gcloud app deploy se utiliza para implementar una aplicación en Google App Engine. Durante la implementación, se suben los archivos y recursos de la aplicación al entorno de App Engine, y se configura automáticamente la escalabilidad, los recursos y otros detalles según la configuración definida en el archivo de configuración de la aplicación (como app.yaml).

Algunas consideraciones importantes:

- Antes de ejecutar este comando, asegúrate de haber configurado correctamente el archivo app.yaml para definir la configuración de tu aplicación.

- Durante la implementación, el comando mostrará información relevante sobre el proceso y te pedirá confirmación antes de continuar.

- Después de la implementación, tu aplicación estará disponible en la URL proporcionada por Google App Engine.


**Consejo:** Utiliza la bandera --version seguida de un nombre para asignar un nombre a la versión específica que se está implementando. Esto puede ser útil para llevar un registro de las versiones de tu aplicación.

Ejemplo:

`gcloud app deploy --version=v1`


<br>

---

## Conclusiones
Al finalizar este laboratorio, habrás aprendido a desplegar una aplicación web en Python utilizando Google App Engine en Google Cloud Platform (GCP). Y habrás aprendido que App Engine nos puede ser muy útil para implementar y escalar aplicaciones web de manera sencilla y eficiente.

