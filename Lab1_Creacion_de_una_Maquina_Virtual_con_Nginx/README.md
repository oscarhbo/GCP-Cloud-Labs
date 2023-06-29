# Laboratorio 1: Creación de una Máquina Virtual con Nginx

Bienvenido al primer laboratorio de este repositorio, aquí aprenderás a crear una máquina virtual en Google Cloud Platform (GCP) y configurar Nginx como servidor web.

---

<!--![diagrama](./imagenes/diagrama.png){width=50%}-->

<p align="center">
  <img src="./imagenes/diagrama.png" alt="diagrama" width="50%" height="50%">
</p>


## Antes de comenzar
Antes de comenzar este laboratorio, es necesario que tengas una cuenta en GCP y conozcas los conceptos básicos de la plataforma.

## Objetivo
El objetivo de este laboratorio es aprender a crear una máquina virtual en GCP y configurar Nginx como servidor web.

## Instrucciones


Este Lab tiene dos modalidades: 

---
### Modalidad Paso a Paso

Ejecutar de forma manual cada una de las instrucciones, lo que permite visualizar y explorar el avance desde la consola. Para ello ejecuta los siguientes pasos:

### Creación de un Máquina Virtual (VM)

1. Acceder a la consola de Google Cloud Platform y abrir Cloud Shell.

2. Crear el shell para instalar un nginx en debian con el siguiente comando 

`echo '#! /bin/bash
sudo apt-get update
sudo apt-get -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx' > install_nginx.sh`

3. Crear la instancia en GCE con el siguiente comando:

`gcloud compute instances create vmprb-nginx01 \
  --image-family ubuntu-2004-lts \
  --image-project ubuntu-os-cloud \
  --create-disk size=10GB \
  --preemptible \
  --boot-disk-size 10GB \
  --boot-disk-type pd-standard \
  --tags http-server \
  --metadata-from-file startup-script=install_nginx.sh \
  --zone=us-central1-b`

4. Ahora para validaremos que la VM se haya completado con éxito, primero definimos las variables de ambiente para el nombre de la VM y para la Zona 

`vm_name=vmprb-nginx01
zone=us-central1-b`

5. Para validar la existencia de la VM pordemos realizarlo de varias formas

`gcloud compute instances list` -> Listará las instancias creadas en el proyecto en donde estemos parados

`gcloud compute instances list --filter="name=$vm_name AND zone:$zone"` -> Con esto podemos ser más específicos para filtrar la máquina

`gcloud compute instances describe "$vm_name" --zone="$zone"` -> De esta forma podemos describir la vm

6. Para validar el servidor nginx podemos hacer lo siguiente: 
   
   Primero obtener la ip de la vm y almacenarla en la variable vm_ip

    `vm_ip=$(gcloud compute instances describe $vm_name --zone $zone --format='value(networkInterfaces[0].accessConfigs[0].natIP)')`

7. Después ejecutar una petición con la utilidad de curl para ver si responde

    `curl http://$vm_ip:80`

    El punto anterior no funcionará, ya que no hemos abierto el tráfico de red aún para el puerto 80, por lo que será necesario cancelar su ejecución con un Control-C

8. Para permitir el tráfico http, es necesario crear una FireWall Rule con el siguiente comando.

`gcloud compute firewall-rules create allow-http \
  --allow tcp:80 \
  --target-tags http-server \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic"`

  Lo que indica que permitirá a cualquier ip comunicarse por el puerto 80 con las VMs que tenga el tag `http-server`

9. Una vez creada la Firewall Rule , volvemos a hacer la petición:

`curl http://$vm_ip:80` y ahora si debe de ser exitosa.

10. También podrías pegar en un navegar la dirección con tu ip `http://$vm_ip:80` , y el resultado debería de ser el siguiente 

<p align="center">
  <img src="./imagenes/Resultado_nginx.png" alt="Nginx" width="50%" height="50%">
</p>

## ***¡Felicidades!***

Ahora ya has entendido como poder aprovisionar una Máquina Virtual en GCE y como poder tener acceso desde internet mediante llamadas HTTP

---
### Modalidad Automática

Ejecutar de forma automática mediante un shell script. Lo que permitirá ver el resultado del laboratorio, pero realizandolo de forma automática mediante un script. Para ello ejecuta los siguientes pasos:


1. Asegúrate de tener acceso a la CLI de GCP.
2. Abre la consola de cloud shell en GCP.
3. Clona este repositorio y accede a la carpeta "Lab_1: Creación de una Máquina Virtual con Nginx".
4. Ejecuta el script "create_vm.sh" para crear una máquina virtual con el tráfico de http habilitado.
5. Verifica que Nginx está corriendo y que puedes acceder a él desde el navegador web.

## Validaciones


Si se desea realizar las validaciones de forma automática, entonces sólo ejecutar el script `validar_lab.sh`


## Archivos
Este laboratorio incluye los siguientes archivos:
- `create_vm.sh`: script para crear una máquina virtual en GCP con el tráfico de http habilitado.
- `install_nginx.sh`: script para instalar Nginx en la máquina virtual recién creada.
- `validar_lab.sh`: Valida que se hayan completado los objetivos del lab correctamente
- `limpiar_lab.sh`: Este script ayuda e aliminar los recursos aprovisionados en este lab y evitar cargos extras en nuestra cuenta

---

## Ayuda de Comandos utilizados

- `gcloud compute instances create`: Este comando se usa para crear una máquina virtual en Google Cloud.

    Las banderas utilizadas en este comando son las siguientes:

    --`image-family`: Especifica la familia de imágenes que se usará para crear la máquina virtual. En este caso, se está utilizando ubuntu-2004-lts.

    --`image-project`: Especifica el proyecto en el que se encuentra la imagen de la máquina virtual. En este caso, se está utilizando ubuntu-os-cloud.

    --`create-disk`: Especifica el tamaño del disco que se creará para la máquina virtual. En este caso, se está utilizando size=10GB.

    --`metadata-from-file`: Especifica el script que se ejecutará al inicio de la máquina virtual. En este caso, se está utilizando startup-script=install_nginx.sh, para poder realizar la instalación del nginx.

    --`preemptible`: Especifica que la máquina virtual es preemptible, lo que significa que puede ser interrumpida en cualquier momento.

    --`boot-disk-size`: Especifica el tamaño del disco de arranque de la máquina virtual. En este caso, se está utilizando 10GB.

    --`boot-disk-type`: Especifica el tipo de disco de arranque de la máquina virtual. En este caso, se está utilizando pd-standard.

    --`tags`: Especifica una etiqueta que se asignará a la máquina virtual. En este caso, se está utilizando http-server. Esto nos servirá para poder hacer referencia a la máquina en la firewal-rule

    --`zone`: Especifica la zona en la que se creará la máquina virtual. En este caso, se está utilizando us-central1-b.


- `gcloud compute firewall-rules create`: Este comando se usa para crear una regla de firewall que permita el tráfico HTTP a la máquina virtual.


    `gcloud compute firewall-rules create allow-http`: Crea una regla de firewall llamada allow-http
    
    --`allow tcp:80`: Permite el tráfico TCP en el puerto 80

    --`target-tags http-server`: Aplica la regla de firewall a las máquinas virtuales con la etiqueta http-server
    
    --`source-ranges` 0.0.0.0/0: Permite el acceso desde cualquier dirección IP
    
    --`description` "Allow HTTP traffic": Agrega una descripción para la regla de firewall

---

## Conclusiones
Al finalizar este laboratorio, habrás aprendido a crear una máquina virtual en GCP y configurar Nginx como servidor web. Esto es un paso importante para poder desplegar aplicaciones web en la nube.

