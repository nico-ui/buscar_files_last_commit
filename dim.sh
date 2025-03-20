echo "[INFO] Script para buscar archivos en el repositorio"
read -p "[INFO] Deaseas cambiarte de rama? (s/n): " respuesta
if [ "$respuesta" == "s" ]
then
    echo "[INFO] Ramas disponibles:"
    git branch
    read -p "[INFO] Indica el nombre de la rama: " rama
    if [ "$rama" != "" ]
    then
        echo "[INFO] Cambiando de rama a $rama"
        git pull
        git checkout $rama
    else
        echo "[INFO] Nombre de rama NO valido"
    fi
fi

echo "[INFO] Vamos a proceder a buscar los archivos que necesitas"
echo "[INFO] Indica el nombre del archivo: "
read archivo
archivos_encontrados=($(find . -iname "*$archivo*"))

#Crear directorio y limpiar
mkdir -p "$HOME/Documents/2024/Dimension/Check in/"
rm -r "$HOME/Documents/2024/Dimension/Check in/"*


# Muestra y copia los archivos encontrados
echo "[INFO] Archivos encontrados:"
for archivo in "${archivos_encontrados[@]}"; do
    echo "$archivo"
    cp $archivo "$HOME/Documents/2024/Dimension/Check in/"
done

# Imprimir el número de coincidencias encontradas
num_coincidencias=${#archivos_encontrados[@]}
echo "[INFO] Numero de archivos encontrados: $num_coincidencias"


# Enrutar

# Copiar en ruta dimensions

# Fin
echo "[INFO] Archivos copiados en la ruta $HOME/Documents/2024/Dimension/Check in/"


