#!/bin/bash

# Defino los nombre de los recursos que utilizaré
VM_NAME1="web-server-prb1"
ZONE1="us-central1-a"
VM_NAME2="web-server-prb2"
ZONE2="us-central1-b"
INSTANCE_TEMPLATE="imagen1-webserver"
FIREWALL_RULE_HTTP="allow-http"


# Crea la plantilla de la instancia
gcloud compute instance-templates create $INSTANCE_TEMPLATE \
--metadata-from-file startup-script=instala_apache.sh \
--machine-type e2-micro \
--image projects/debian-cloud/global/images/debian-11-bullseye-v20230206 \
--tags http-server \
--boot-disk-size 10 \
--boot-disk-type pd-balanced

# Verifica si la plantilla de instancia se creó satisfactoriamente
if [ $? -ne 0 ]; then
  echo ""
  echo "[Error] Problemas al crear la instance template"
  echo ""
  exit 1
else
  echo "La instance Template $INSTANCE_TEMPLATE ha sido creada correctamente."
  echo ""
fi

# Crea la primer Vm con la plantilla
gcloud compute instances create $VM_NAME1 \
--source-instance-template=$INSTANCE_TEMPLATE \
--zone=$ZONE1

# Verifica si la vm 1 se creó satisfactoriamente
if [ $? -ne 0 ]; then
  echo ""
  echo "[Error] Problemas al crear la VM $VM_NAME1"
  echo ""
  exit 1
else
  echo "La VM $VM_NAME1 ha sido creada correctamente."
  echo ""
fi

# Crea la primer Vm con la plantilla
gcloud compute instances create $VM_NAME2 \
--source-instance-template=$INSTANCE_TEMPLATE \
--zone=$ZONE2

# Verifica si la vm 2 se creó satisfactoriamente
if [ $? -ne 0 ]; then
  echo ""
  echo "[Error] Problemas al crear la VM $VM_NAME2"
  echo ""
  exit 1
else
  echo "La VM $VM_NAME2 ha sido creada correctamente."
  echo ""
fi

# Crear la regla de firewall para abrir el tráfico http
gcloud compute firewall-rules create $$FIREWALL_RULE_HTTP \
  --allow tcp:80 \
  --target-tags http-server \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic"

  # Verifica si la firewall rule se creó satisfactoriamente
if [ $? -ne 0 ]; then
  echo ""
  echo "[Error] Problemas al crear la regla de Firewall $FIREWALL_RULE_HTTP"
  echo ""
  exit 1
else
  echo "La regla de Firewall $FIREWALL_RULE_HTTP ha sido creada correctamente."
  echo ""
fi