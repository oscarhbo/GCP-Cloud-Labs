#!/bin/bash

source ./../../utils/funciones.sh

# Defino los nombre de los recursos que validaré
VM_NAME1="web-server-prb1"
ZONE1="us-central1-a"
VM_NAME2="web-server-prb2"
ZONE2="us-central1-b"
INSTANCE_TEMPLATE="imagen1-webserver"
FIREWALL_RULE_HTTP="allow-http"


if gcloud compute instance-templates describe "$INSTANCE_TEMPLATE"  &> /dev/null; then
  print_msg "[OK] La plantilla de instancias $INSTANCE_TEMPLATE se creó correctamente."
else
  print_msg "[ERROR] La plantilla de instancias $INSTANCE_TEMPLATE no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute instances describe "$VM_NAME1" --zone=$ZONE1 &> /dev/null; then
  print_msg "[OK] La máquina virtual $VM_NAME1 se creó correctamente."
else
  print_msg "[ERROR] La máquina virtual $VM_NAME1 no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute instances describe "$VM_NAME2" --zone=$ZONE2 &> /dev/null; then
  print_msg "[OK] La máquina virtual $VM_NAME2 se creó correctamente."
else
  print_msg "[ERROR] La máquina virtual $VM_NAME2 no se creó correctamente o no existe. Favor de validar"
fi

ip_address=$(gcloud compute instances describe "$VM_NAME1" --zone "$ZONE1" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

echo " "
echo "La ip de la vm $VM_NAME1 es - $ip_address"

response=$(curl -s -o /dev/null -w "%{http_code}" http://"$ip_address":80)

# Verifico si la respuesta es 200 (OK)
if [ "$response" -eq 200 ]; then
  print_msg "[OK] El servidor Nginx en la VM $VM_NAME1 está instalado y responde correctamente por el puerto 80"
else
  print_msg "[ERROR] El servidor Nginx de la VM $VM_NAME1 no está respondiendo o hay un problema en la instalación"
fi

ip_address=$(gcloud compute instances describe "$VM_NAME2" --zone "$ZONE2" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

echo " "
echo "La ip de la vm $VM_NAME2 es - $ip_address"

response=$(curl -s -o /dev/null -w "%{http_code}" http://"$ip_address":80)

# Verifico si la respuesta es 200 (OK)
if [ "$response" -eq 200 ]; then
  print_msg "[OK] El servidor Nginx en la VM $VM_NAME2 está instalado y responde correctamente por el puerto 80"
else
  print_msg "[ERROR] El servidor Nginx de la VM $VM_NAME2 no está respondiendo o hay un problema en la instalación"
fi
