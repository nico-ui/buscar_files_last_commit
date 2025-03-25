#!/bin/bash

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

#Crear directorio y limpiar
DEST_DIR="$HOME/Documents/2024/Dimension/Check in/"
mkdir -p "$DEST_DIR"

# Verificar si el directorio esta vacio
if [ -z "$(ls -A "$DEST_DIR")" ]; then
    echo "[INFO] El directorio destino esta vacio."
else
    echo "[INFO] El directorio destino no esta vacio. Limpiando el directorio..."
    rm -rf "$DEST_DIR"/{*,.*}
fi

# Obtener los archivos .xml, .properties, .xls, .sh y .java modificados o añadidos del ultimo commit
archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD | grep -E '\.(xml|properties|xls|sh|java)$'))

# Imprimir el numero de archivos .xml nuevos encontrados
num_coincidencias=${#archivos_nuevos[@]}
echo "[INFO] Numero de archivos .xml nuevos encontrados: $num_coincidencias"

# Muestra y copia los archivos nuevos encontrados
echo "[INFO] Archivos .xml nuevos encontrados:"
for archivo in "${archivos_nuevos[@]}"; do
    echo "$archivo"
    # Obtener el directorio padre del archivo y eliminar las carpetas antes e igual a "nacar"
    ruta_modificada=$(echo "$archivo" | sed -e 's/.*nacar\///')
    # Crear la estructura de directorios en el destino
    mkdir -p "$DEST_DIR$(dirname "$ruta_modificada")"
    # Copiar el archivo al destino
    cp "$archivo" "$DEST_DIR$ruta_modificada"

    # Si el archivo es .java, compilarlo y copiar el .class resultante
    if [[ "$archivo" == *.java ]]; then
        javac "$archivo"
        class_file="${archivo%.java}.class"
        if [ -f "$class_file" ]; then
            ruta_modificada_class=$(echo "$class_file" | sed -e 's/.*nacar\///')
            mkdir -p "$DEST_DIR$(dirname "$ruta_modificada_class")"
            cp "$class_file" "$DEST_DIR$ruta_modificada_class"
        fi
    fi
done

# Enrutar

# Copiar en ruta dimensions

# Fin
echo "[INFO] Archivos copiados en la ruta $HOME/Documents/2024/Dimension/Check in/"


