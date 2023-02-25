#!/bin/bash

echo "Listado de Buckets existentes en el proyecto:"
echo "----------------------------------------------"
echo ""

gsutil ls | awk -F'/' '{print NR-1,$3}'

echo ""
echo -n "Ingresa el número del bucket que deseas eliminar: "
read bucket_num

bucket_name=$(gsutil ls | awk -F'/' -v bucket_num="$bucket_num" 'NR-1 == bucket_num {print $3}')

echo ""
echo "El bucket seleccionado es: ${bucket_name}"
echo -n "¿Estás seguro que deseas eliminar este bucket? [S/n]: "
read confirmacion

if [[ $confirmacion == "S" || $confirmacion == "s" ]]; then
  echo "Eliminando el bucket ${bucket_name}..."
  gsutil rm -r "gs://${bucket_name}"
  echo "Bucket ${bucket_name} eliminado exitosamente."
else
  echo "La eliminación del bucket ha sido cancelada."
fi
