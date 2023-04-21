#!/bin/bash

VM_NAME1="web-server-prb1"
ZONE1="us-central1-a"
VM_NAME2="web-server-prb2"
ZONE2="us-central1-b"
INSTANCE_TEMPLATE="imagen1-webserver"

echo "Eliminando máquina virtual  $VM_NAME1 ..."
gcloud compute instances delete "$VM_NAME1" --zone "$ZONE1"

echo "Eliminando máquina virtual  $VM_NAME2 ..."
gcloud compute instances delete "$VM_NAME2" --zone "$ZONE2"


echo "Eliminando regla de firewall allow-http ..."
gcloud compute firewall-rules delete "allow-http"

echo "Eliminando la instance template $INSTANCE_TEMPLATE ..."
gcloud compute instance-templates delete "$INSTANCE_TEMPLATE"


echo "Máquina virtual, regla de firewall e instance template eliminadas con éxito."
