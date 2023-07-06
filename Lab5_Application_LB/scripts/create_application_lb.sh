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


# Se crea la plantilla de instancias
gcloud compute instance-templates create $INSTANCE_TEMPLATE \
   --region=$DEF_REGION \
   --network=default \
   --subnet=default \
   --tags=$NET_TAG \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Página mostrada desde la vm: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear la instance template $INSTANCE_TEMPLATE"
  exit 2
else
  print_msg "La instance template $INSTANCE_TEMPLATE se creó de forma correcta."
fi


# Se crea el grupo de instancias que servirá como backend
gcloud compute instance-groups managed create $INSTANCE_GROUP \
   --template=$INSTANCE_TEMPLATE --size=2 --zone=$DEF_ZONE 

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear el grupo de instancias $INSTANCE_GROUP"
  exit 2
else
  print_msg "El grupo de instancias $INSTANCE_GROUP  se creó de forma correcta."
fi

# Se crea la firewall rule para check de salud
gcloud compute firewall-rules create $REGLA_FIREWALL_LB \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=$NET_TAG \
  --rules=tcp:80

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear la firewall rule $REGLA_FIREWALL_LB"
  exit 2
else
  print_msg "La firewall rule $REGLA_FIREWALL_LB se creó de forma correcta."
fi


# Se crea una Ip estática para el Load Balancer
gcloud compute addresses create $IP_LB \
  --ip-version=IPV4 \
  --global

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear ip estática $IP_LB"
  exit 1
else
  print_msg "La Ip estática $IP_LB ha sido creada correctamente."
fi

# Se crea el Health Check
gcloud compute health-checks create http $HEALTH_CHECK \
  --port 80

if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear Health Check $HEALTH_CHECK"
  exit 1
else
  print_msg "El Health Check $HEALTH_CHECK ha sido creado correctamente."
fi

# Se crea el servicio backend para el lb
gcloud compute backend-services create $BACKEND_NAME \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=$HEALTH_CHECK \
  --global


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear el servicio backend $BACKEND_NAME"
  exit 1
else
  print_msg "El servicio backend $BACKEND_NAME ha sido creado correctamente."
fi


# Se agrega el grupo de instancias como backend al servicio de backend 
gcloud compute backend-services add-backend $BACKEND_NAME \
  --instance-group=$INSTANCE_GROUP \
  --instance-group-zone=$DEF_ZONE \
  --global


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al agregar el grupo de instancias  $INSTANCE_GROUP como backend"
  exit 1
else
  print_msg "El grupo de instancias $INSTANCE_GROUP ha sido agregado correctamente como backend."
fi

# Se crea mapeo de URLs para enrutar las solicitudes entrantes al servicio de backend 
gcloud compute url-maps create $URL_MAP \
    --default-service $BACKEND_NAME


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear mapeo de URL $URL_MAP"
  exit 1
else
  print_msg "El mapeo de URLs $URL_MAP ha sido creado correctamente."
fi

# Se crea Proxy HTTP de destino para enrutar las solicitudes al mapa de URLs
gcloud compute target-http-proxies create $TARGET_PROXY \
    --url-map $URL_MAP


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear target proxy $TARGET_PROXY"
  exit 1
else
  print_msg "El target proxy $TARGET_PROXY ha sido creado correctamente."
fi


# Se crea regla de reenvío global para enrutar las solicitudes entrantes al proxy
gcloud compute forwarding-rules create $FW_RULE_HTTP \
    --address=$IP_LB\
    --global \
    --target-http-proxy=$TARGET_PROXY \
    --ports=80


if [ $? -ne 0 ]; then
  echo ""
  print_msg "[Error] Problemas al crear regla de reenvío $FW_RULE_HTTP"
  exit 1
else
  print_msg "La regla de reenvío $FW_RULE_HTTP ha sido creada correctamente."
fi


echo ""

print_msg "¡Listo todos los pasos se ejecutaron correctamente!"
