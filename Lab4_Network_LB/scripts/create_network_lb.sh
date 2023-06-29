#!/bin/bash

source ./../../utils/funciones.sh


# Defino los nombre de los recursos que utilizaré
WEB_SERVER1="vm-webserver1"
WEB_SERVER2="vm-webserver2"
WEB_SERVER3="vm-webserver3"
REGLA_NET_LB="www-firewall-network-lb"
IP_LB="network-lb-ip-1"
HEALTH_CHECK="basic-check"
WS_TARGET_POOL="www-pool"
FW_RULE_WWW="www-rule"

# Se configura la zona de disponibilidad predeterminada
gcloud config set compute/zone us-east1-d

# Se configura la región predeterminada
gcloud config set compute/region us-east1


# Se crea la primera VM que será nuestro Web server 1
gcloud compute instances create $WEB_SERVER1 \
    --zone=us-east1-d \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>  ESTÁS EN EN EL SERVIDOR WEB NÚMERO 1.   </h3>" | tee /var/www/html/index.html'

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear la máquina virtual $WEB_SERVER1"
  exit 2
else
  print_msg "La máquina virtual $WEB_SERVER1  se creó de forma correcta."
fi


# Se crea la primera VM que será nuestro Web server 2
gcloud compute instances create $WEB_SERVER2 \
    --zone=us-east1-d \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>  ESTÁS EN EN EL SERVIDOR WEB NÚMERO 2.   </h3>" | tee /var/www/html/index.html'

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear la máquina virtual $WEB_SERVER2"
  exit 2
else
  print_msg "La máquina virtual $WEB_SERVER2  se creó de forma correcta."
fi

# Se crea la primera VM que será nuestro Web server 3
gcloud compute instances create $WEB_SERVER3 \
    --zone=us-east1-d \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>  ESTÁS EN EN EL SERVIDOR WEB NÚMERO 3.   </h3>" | tee /var/www/html/index.html'

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear la máquina virtual $WEB_SERVER3"
  exit 2
else
  print_msg "La máquina virtual $WEB_SERVER3 se creó de forma correcta."
fi

# Se crea la firewall-rule para permitir el tráfico por el puerto 80
gcloud compute firewall-rules create $REGLA_NET_LB \
    --target-tags network-lb-tag --allow tcp:80

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear firewall-rule $REGLA_NET_LB"
  exit 1
else
  print_msg "firewall-rule $REGLA_NET_LB ha sido creada correctamente."
fi

# Obtenemos las ips de las máquinas virtuales
VM_IP1=$(gcloud compute instances describe $WEB_SERVER1 --zone us-east1-d --format='value(networkInterfaces[0].accessConfigs[0].natIP)')
VM_IP2=$(gcloud compute instances describe $WEB_SERVER2 --zone us-east1-d --format='value(networkInterfaces[0].accessConfigs[0].natIP)')
VM_IP3=$(gcloud compute instances describe $WEB_SERVER3 --zone us-east1-d --format='value(networkInterfaces[0].accessConfigs[0].natIP)')


RESPONSE1=$(curl -s -o /dev/null -w "%{http_code}" http://"$VM_IP1":80)

# Verifico si la respuesta es 200 (OK)
if [ "$RESPONSE1" -eq 200 ]; then
  print_msg "[OK] El servidor $WEB_SERVER1 está arriba y responde correctamente por el puerto 80"
else
  print_msg "[ERROR] El servidor $WEB_SERVER1 no está respondiendo o hay un problema en el despliegue"
fi

RESPONSE2=$(curl -s -o /dev/null -w "%{http_code}" http://"$VM_IP2":80)

# Verifico si la respuesta es 200 (OK)
if [ "$RESPONSE2" -eq 200 ]; then
  print_msg "[OK] El servidor $WEB_SERVER2 está arriba y responde correctamente por el puerto 80"
else
  print_msg "[ERROR] El servidor $WEB_SERVER2 no está respondiendo o hay un problema en el despliegue"
fi

RESPONSE3=$(curl -s -o /dev/null -w "%{http_code}" http://"$VM_IP3":80)

# Verifico si la respuesta es 200 (OK)
if [ "$RESPONSE3" -eq 200 ]; then
  print_msg "[OK] El servidor $WEB_SERVER3 está arriba y responde correctamente por el puerto 80"
else
  print_msg "[ERROR] El servidor $WEB_SERVER3 no está respondiendo o hay un problema en el despliegue"
fi


# Se crea una Ip estática para el Load Balancer
gcloud compute addresses create $IP_LB --region us-east1

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear ip estática $IP_LB"
  exit 1
else
  print_msg "La Ip estática $IP_LB ha sido creada correctamente."
fi

# Se crea el Health Check
gcloud compute http-health-checks create $HEALTH_CHECK

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear Health Check $HEALTH_CHECK"
  exit 1
else
  print_msg "El Health Check $HEALTH_CHECK ha sido creado correctamente."
fi

# Se crea el taget pool en donde se pondrán las instancias
gcloud compute target-pools create $WS_TARGET_POOL \
    --region us-east1 --http-health-check $HEALTH_CHECK


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear el target pool $WS_TARGET_POOL"
  exit 1
else
  print_msg "El target pool $WS_TARGET_POOL ha sido creado correctamente."
fi

# Se adicionan las tres instancias al Target Pool
gcloud compute target-pools add-instances $WS_TARGET_POOL \
    --instances $WEB_SERVER1,$WEB_SERVER2,$WEB_SERVER3


# Se crea la regla de reenvío
gcloud compute forwarding-rules create $FW_RULE_WWW \
    --region  us-east1 \
    --ports 80 \
    --address $IP_LB \
    --target-pool $WS_TARGET_POOL

echo ""

print_msg "¡Listo todos los pasos se ejecutaron correctamente!"
