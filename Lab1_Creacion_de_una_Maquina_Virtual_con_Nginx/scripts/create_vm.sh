#!/bin/bash

# Crear la m�quina virtual preemptible en GCP
gcloud compute instances create vmprb-nginx01 \
  --image-family ubuntu-2004-lts \
  --image-project ubuntu-os-cloud \
  --create-disk size=10GB \
  --preemptible \
  --boot-disk-size 10GB \
  --boot-disk-type pd-standard \
  --tags http-server \
  --metadata-from-file startup-script=install_nginx.sh \
  --zone=us-central1-b

# Abrir el tr�fico HTTP para la m�quina virtual
gcloud compute firewall-rules create allow-http \
  --allow tcp:80 \
  --target-tags http-server \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic"
  
