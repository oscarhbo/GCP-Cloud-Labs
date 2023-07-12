#!/bin/bash

source ./../../utils/funciones.sh

# Defino los nombre de los recursos que utilizaré
INSTANCE_TEMPLATE="lb-backend-template"
NET_TAG="allow-health-check"
REGLA_FIREWALL_LB="fw-allow-health-check"
IP_LB="lb-ipv4-1"
HEALTH_CHECK="http-basic-check"
BACKEND_NAME="web-backend-service"
URL_MAP="web-map-http"
TARGET_PROXY="http-lb-proxy"
FW_RULE_HTTP="http-content-rule"
INSTANCE_GROUP="lb-backend-group"
DEF_REGION="us-east1"
DEF_ZONE="us-east1-d"


#if gcloud compute instances describe "$WEB_SERVER1" --zone=$ZONE &> /dev/null; then
#  print_msg "[OK] La máquina virtual $WEB_SERVER1 se creó correctamente."
#else
#  print_msg "[ERROR] La máquina virtual $WEB_SERVER1 no se creó correctamente o no existe. Favor de validar"
#fi


# revisar si es necesario poner la validación la salud de todas las instancias del grupo de instancias.



if gcloud compute firewall-rules describe "$REGLA_FIREWALL_LB" &> /dev/null; then
  print_msg "[OK] La firewall-rule $REGLA_FIREWALL_LB se creó correctamente."
else
  print_msg "[ERROR] La firewall-rule $REGLA_FIREWALL_LB no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute backend-services describe "$BACKEND_NAME" --global &> /dev/null; then
  print_msg "[OK] El backend-service $BACKEND_NAME se creó correctamente."
else
  print_msg "[ERROR] El backend-service $BACKEND_NAME no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute url-maps describe "$URL_MAP" &> /dev/null; then
  print_msg "[OK] El mapa de URL $URL_MAP se creó correctamente."
else
  print_msg "[ERROR] El mapa de URL $URL_MAP no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute target-http-proxies describe "$TARGET_PROXY" &> /dev/null; then
  print_msg "[OK] El target proxy $TARGET_PROXY se creó correctamente."
else
  print_msg "[ERROR] El target proxy $TARGET_PROXY no se creó correctamente o no existe. Favor de validar"
fi

if gcloud compute forwarding-rules describe "$FW_RULE_HTTP" --global &> /dev/null; then
  print_msg "[OK] La forwarding-rule $FW_RULE_HTTP se creó correctamente."
else
  print_msg "[ERROR] La forwarding-rule $FW_RULE_HTTP no se creó correctamente o no existe. Favor de validar"
fi

IPEXTERNA_LB=$(gcloud compute forwarding-rules describe http-content-rule --global --format="value(IPAddress)")

print_msg "La ip estática que se usa para el Load Balancer es  - $IPEXTERNA_LB"

for ((i=1; i<=10; i++)); do curl -m1 $IPEXTERNA_LB; done