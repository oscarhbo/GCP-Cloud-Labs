#!/bin/bash

source ./../../utils/funciones.sh

# Defino los nombre de los recursos que utilizaré
ZONE="us-east1-d"
REGION="us-east1"
WEB_SERVER1="vm-webserver1"
WEB_SERVER2="vm-webserver2"
WEB_SERVER3="vm-webserver3"
REGLA_NET_LB="www-firewall-network-lb"
IP_LB="network-lb-ip-1"
HEALTH_CHECK="basic-check"
WS_TARGET_POOL="www-pool"
FW_RULE_WWW="www-rule"


if gcloud compute instances describe "$WEB_SERVER1" --zone=$ZONE &> /dev/null; then
  print_msg "[OK] La máquina virtual $WEB_SERVER1 se creó correctamente."
else
  print_msg "[ERROR] La máquina virtual $WEB_SERVER1 no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute instances describe "$WEB_SERVER2" --zone=$ZONE &> /dev/null; then
  print_msg "[OK] La máquina virtual $WEB_SERVER2 se creó correctamente."
else
  print_msg "[ERROR] La máquina virtual $WEB_SERVER2 no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute instances describe "$WEB_SERVER3" --zone=$ZONE &> /dev/null; then
  print_msg "[OK] La máquina virtual $WEB_SERVER3 se creó correctamente."
else
  print_msg "[ERROR] La máquina virtual $WEB_SERVER3 no se creó correctamente o no existe. Favor de validar"
fi


VM_IP1=$(gcloud compute instances describe $WEB_SERVER1 --zone "$ZONE" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')
VM_IP2=$(gcloud compute instances describe $WEB_SERVER2 --zone "$ZONE" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')
VM_IP3=$(gcloud compute instances describe $WEB_SERVER3 --zone "$ZONE" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')

print_msg "La ip de la vm $WEB_SERVER1 es - $VM_IP1"
print_msg "La ip de la vm $WEB_SERVER2 es - $VM_IP2"
print_msg "La ip de la vm $WEB_SERVER3 es - $VM_IP3"

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

if gcloud compute firewall-rules describe "$REGLA_NET_LB" &> /dev/null; then
  print_msg "[OK] La firewall-rule $REGLA_NET_LB se creó correctamente."
else
  print_msg "[ERROR] La firewall-rule $REGLA_NET_LB no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute target-pools describe "$WS_TARGET_POOL" --region=$REGION &> /dev/null; then
  print_msg "[OK] El Target pool $WS_TARGET_POOL se creó correctamente."
else
  print_msg "[ERROR] El Target pool $WS_TARGET_POOL no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute forwarding-rules describe "$FW_RULE_WWW" --region=$REGION &> /dev/null; then
  print_msg "[OK] La forwarding-rule $FW_RULE_WWW se creó correctamente."
else
  print_msg "[ERROR] La forwarding-rule $FW_RULE_WWW no se creó correctamente o no existe. Favor de validar"
fi

IPEXTERNA_LB=$(gcloud compute forwarding-rules describe $FW_RULE_WWW --region $REGION --format="json" | jq -r .IPAddress)

print_msg "La ip estática que se usa para el Load Balancer es  - $IPEXTERNA_LB"

for ((i=1; i<=10; i++)); do curl -m1 $IPEXTERNA_LB; done