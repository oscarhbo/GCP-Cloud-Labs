#!/bin/bash

vm_name=vmprb-nginx01

if gcloud compute instances describe "$vm_name" &> /dev/null; then
  echo "La máquina virtual $vm_name se creó correctamente."
else
  echo "Error: La máquina virtual $vm_name no se creó correctamente o no existe. Favor de validar"
  exit 1
fi
