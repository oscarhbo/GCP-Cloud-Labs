# Laboratorio 2: Configuración del Almacenamiento en Cloud Storage

Bienvenido al laboratorio #2 de este repositorio, aquí aprenderás a crear crear un bucket de almacenamiento, subir objetos a él, crear carpetas y subcarpetas en él y permitir el acceso público a los objetos con la línea de comandos de Google Cloud.

## Antes de comenzar
Antes de comenzar este laboratorio, es necesario que tengas una cuenta en GCP y conozcas los conceptos básicos de la plataforma.

## Objetivo
Los objetivos de este laboratorio son los siguientes:

- Crear un Bucket de Cloud Storage
- Subir un archivo al Bucket
- Descargar un archivo del Bucket
- Crear una Carpeta en el Bucket
- Configurar permisos de acceso a un Bucket

## Instrucciones


Este Lab tiene dos modalidades: 

---
### Modalidad Paso a Paso

Ejecutar de forma manual cada una de las instrucciones, lo que permite visualizar y explorar el avance desde la consola. Para ello ejecuta los siguientes pasos:

### Creación de un Bucket 

1. Acceder a la consola de Google Cloud Platform y abrir Cloud Shell.
2. Crear un Bucket de Cloud Storage con el siguiente comando:

`gsutil mb -l us-central1 gs://BUCKET-NAME/`

3. Puedes validar la creación del bucket con el siguiente comando 

`gsutil ls -p $GOOGLE_CLOUD_PROJECT | grep gs://BUCKET-NAME/`

### Carga de un Archivo a un Bucket

4. Descarga una imagen desde cloud shell, con el siguiente comando

`curl https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Programming_code.jpg/640px-Programming_code.jpg --output code.jpg`

4. Copia la imagen a Cloud Storage con el siguiente comando

`gsutil cp code.jpg gs://BUCKET-NAME`

5. Ahora eliminamos la imagen que habíamos descargado previamente en la vm de cloud shell

`rm code.jpg`

### Descarga de un objeto desde un Bucket

6. Ejecutamos el siguiente comando para descargar el archivo desde nuestro bucket

`gsutil cp -r gs://BUCKET-NAME/code.jpg .`

7. Si todo es correcto podremos ver nuestra archivo ejecutando desde cloud shell lo siguiente

`ls -l code.jpg`

### Copiar un objeto dentro de una carpeta de un Bucket

8. Usaremos el comando gsutil `cp` para crear una carpeta llamada imagenes y copia la imagen (code.jpg) en ella:

`gsutil cp gs://BUCKET-NAME/code.jpg gs://BUCKET-NAME/imagenes/`

9. Para validar si la carpeta se generó y el archivo fue copiado correctamente se puede ejecutar el siguiente comando 

`gsutil ls gs://BUCKET-NAME/imagenes/code.jpg`

10. Para ver los detalles de ese objeto se puede incluir la bandera -l 

`gsutil ls -l gs://BUCKET-NAME/imagenes/code.jpg`

### Permitir el acceso público al objeto

11. Usaremos el comando `gsutil acl ch` a fin de que todos los usuarios tengan permisos de lectura para el objeto almacenado en el bucket

`gsutil acl ch -u AllUsers:R gs://BUCKET-NAME/code.jpg`

12. Para validar que el objeto ya sea de acceso público prueba ejecutando la siguiente URL desde un navegador

`https://storage.googleapis.com/BUCKET-NAME/code.jpg`

### Eliminar el acceso público al objetos

13. Posteriormente para quitar el acceso público lo realizamos con el siguiente comando 

`gsutil acl ch -d AllUsers gs://BUCKET-NAME/code.jpg` 

14. Verificar nuevamente con la url anterior y ya no debe de haber acceso al objeto

### Borrar objetos del bucket

15. Para eliminar el objeto de el Bucket lo hacemos con el siguiente comando

`gsutil rm gs://BUCKET-NAME/code.jpg`

16. Para validar que el elemento haya sido eliminado , podemos ejecutar el comando 

`gsutil ls gs://BUCKET-NAME/code.jpg`

---
## ***¡Felicidades!***

Ahora ya has entendido como realizar las tareas principales dentro de Cloud Storage


---
### Modalidad Automática

Ejecutar de forma automática mediante un script. Lo que permitirá ver el resultado pero con un script de forma automática. Para ello ejecuta los siguientes pasos:

1. Acceder a la consola de Google Cloud Platform y abrir Cloud Shell.
2. Clona este repositorio y accede a la carpeta "Lab2_Configuracion_de_Almacenamiento_en_la_Nube".
3. Da permisos de ejecución a los archivos create_bucket.sh, limpiar_lab.sh y validar_lab.sh con el comando `chmod +x [nombre_archivo]`
4. Ejecuta el script "create_bucket.sh" para crear el bucket y realizar tareas adicionales


## Validaciones
Para poder validar el resultado del Lab puedes realizar lo siguiente

`gsutil ls gs://$BUCKET_NAME` -> Listará todos los buckets creados en el proyecto
`gsutil ls "gs://${BUCKET_NAME}/code.jpg` -> Listará el objeto creado en el bucket si en realidad existe

Si se desea realizar las validaciones de forma automática, entonces sólo ejecutar el script `validar_lab.sh`

## Archivos
Este laboratorio incluye los siguientes archivos:
- `create_bucket.sh`: script para crear un bucket en cloud storage, descargar una imagen muestra a cloud shell y cargarla al bucket creado.
- `validar_lab.sh`: Valida que se hayan completado los objetivos del lab correctamente
- `limpiar_lab.sh`: Este script ayuda e aliminar los recursos aprovisionados en este lab y evitar cargos extras en nuestra cuenta

---

## Ayuda de Comandos utilizados

- `gsutil mb -l us-central1 gs://BUCKET-NAME/`: El comando crea un nuevo bucket en Google Cloud Storage con el nombre especificado en BUCKET-NAME y lo ubica en la región us-central1

    Las banderas utilizadas en este comando son las siguientes:

    -`l`: location, para indicar en donde se creará el bucket
    
    además se pueden indicar las siguientes opciones:

    -`b`: establece el nivel de acceso de los objetos del bucket a "Acceso uniforme".

    -`c`: especifica la clase de almacenamiento para el bucket (por ejemplo, "STANDARD" o "NEARLINE").

    -`p`: especifica el proyecto donde se creará el bucket.

    -`r`: habilita la retrocompatibilidad para el bucket (se utiliza para crear buckets que imitan los comportamientos de versiones anteriores de Cloud Storage).

    La lista completa lista de las opciones están disponibles en la documentación de gsutil: https://cloud.google.com/storage/docs/gsutil/commands/mb

---

## Conclusiones
Al finalizar este laboratorio, habrás aprendido a crear un bucket en cloud storage subir objetos a él, crear carpetas y subcarpetas en él y permitir el acceso público a los objetos con la línea de comandos de Google Cloud. Lo que es necesario para el manejo de almacenamiento de tipo Objeto en la  nube.


