#!/bin/bash

vm_name=vmprb-nginx01
zone="us-central1-b"


if gcloud compute instances describe "$vm_name" --zone=us-central1-b &> /dev/null; then
  echo "[OK] La máquina virtual $vm_name se creó correctamente."
else
  echo "[ERROR] La máquina virtual $vm_name no se creó correctamente o no existe. Favor de validar"
fi

ip_address=$(gcloud compute instances describe "$vm_name" --zone "$zone" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

echo " "

response=$(curl -s -o /dev/null -w "%{http_code}" http://"$ip_address":80)

# Verifico si la respuesta es 200 (OK)
if [ "$response" -eq 200 ]; then
  echo "[OK] El servidor Nginx está instalado y responde correctamente por el puerto 80"
else
  echo "[ERROR] El servidor Nginx no está respondiendo o hay un problema en la instalación"
fi
