#!/bin/bash

vm_name="vmprb-nginx01"
zone="us-central1-b"

echo "Eliminando máquina virtual $vm_name ..."
gcloud compute instances delete "$vm_name" --zone "$zone"

echo "Eliminando regla de firewall allow-http ..."
gcloud compute firewall-rules delete "allow-http"

echo "Máquina virtual y regla de firewall eliminadas con éxito."
