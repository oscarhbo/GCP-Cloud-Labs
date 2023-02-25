#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "ERROR: Debes proporcionar un nombre de bucket como argumento"
    exit 1
fi

BUCKET_NAME=$1

if gsutil ls gs://$BUCKET_NAME &>/dev/null; then
    echo "[OK] El bucket $BUCKET_NAME se creó correctamente."
else
    echo "[ERROR] El bucket $BUCKET_NAME no se creó correctamente o no existe. Favor de validar"
    exit 1
fi


if gsutil ls "gs://${BUCKET_NAME}/code.jpg" &>/dev/null; then
    echo "[OK] La imagen code.jpg se cargó correctamente en el bucket $BUCKET_NAME."
else
    echo "[ERROR] La imagen code.jpg no existe en el bucket $BUCKET_NAME."
    exit 1
fi
