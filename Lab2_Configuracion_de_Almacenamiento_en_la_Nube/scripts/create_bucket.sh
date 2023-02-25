#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "ERROR: Debes proporcionar un nombre de bucket como argumento"
    exit 1
fi

BUCKET_NAME=$1

# Crea el bucket en la región us-central1
gsutil mb -l us-central1 gs://$BUCKET_NAME/

if [ $? -ne 0 ]; then
  echo ""
  echo "[Error] Problemas al crear el bucket"
  echo ""
  exit 1
else
  echo "El bucket $BUCKET_NAME ha sido creado correctamente."
  echo ""
fi

# Descarga la imagen de ejemplo y la guarda como "code.jpg" en el directorio actual
curl https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Programming_code.jpg/640px-Programming_code.jpg --output code.jpg

echo "La imagen se descargó correctamente a cloud shell"
echo ""

# Copia la imagen al bucket recién creado
gsutil cp code.jpg gs://$BUCKET_NAME

if [ $? -ne 0 ]; then
  echo ""
  echo "Error] Problemas al copiar la imagen dentro del bucket"
  echo ""
  exit 2
else
  echo "La imagen ha sido copiada al bucket $BUCKET_NAME  de forma correcta."
  echo ""
fi


# Borra la imagen del directorio actual
rm code.jpg
echo  "Se eliminó la imagen de cloud shell."

echo ""

echo "¡Listo todos los pasos se ejecutaron correctamente!"
