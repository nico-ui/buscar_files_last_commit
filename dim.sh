#!/bin/bash

echo "[INFO] Script para buscar archivos en el repositorio"
# git pull

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
    echo "[INFO] El directorio destino $DEST_DIR esta vacio."
else
    echo "[INFO] El directorio destino no esta vacio. Limpiando el directorio..."
    rm -rf "$DEST_DIR"/{*,.*}
fi

echo "[INFO] Buscando archivos .xml, .properties, .xls y .sh nuevos en el ultimo commit..."
# Mostrar el ultimo commit
echo "[INFO] Buscando en el Ultimo commit:"
git log --oneline -1

# Obtener los archivos .xml, .properties, .xls, .sh y .java modificados o añadidos del ultimo commit
# archivos_nuevos=($(git diff --name-only --diff-filter=MA $(git merge-base HEAD origin/$(git rev-parse --abbrev-ref HEAD)) | grep -E '\.(xml|properties|xls|sh)$'))
archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD | grep -E '\.(xml|properties|xls|sh)$'))
# Detecta si el último commit es un merge
if [ "$(git rev-list --parents -n 1 HEAD | wc -w)" -gt 2 ]; then
    echo "[INFO] El último commit es un merge. Buscando archivos modificados entre los padres..."
    PARENT1=$(git rev-parse HEAD^0)
    echo "[INFO] Padre 1: $PARENT1"
    PARENT2=$(git rev-parse HEAD^1)
    echo "[INFO] Padre 2: $PARENT2"
    archivos_nuevos=($(git diff --name-only --diff-filter=MA $PARENT1 $PARENT2 | grep -E '\.(xml|properties|xls|sh)$'))
else
    archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD | grep -E '\.(xml|properties|xls|sh)$'))
fi

# Imprimir el numero de archivos .xml nuevos encontrados
num_coincidencias=${#archivos_nuevos[@]}
echo "[INFO] Numero de archivos .xml nuevos encontrados: $num_coincidencias"
# echo "$archivos_nuevos"

# Muestra y copia los archivos nuevos encontrados
echo "[INFO] Archivos nuevos encontrados:"
i=1;
for archivo in "${archivos_nuevos[@]}"; do
    echo "$i) $archivo"
    # Obtener el directorio padre del archivo y eliminar las carpetas antes e igual a "nacar"
    ruta_modificada=$(echo "$archivo" | sed -e 's/.*nacar\///')
    # Crear la estructura de directorios en el destino
    mkdir -p "$DEST_DIR$(dirname "$ruta_modificada")"
    # Copiar el archivo al destino
    cp "$archivo" "$DEST_DIR$ruta_modificada"
    # Incrementar el contador
    ((i++))
done

# Fin
echo "[INFO] Archivos copiados en la ruta $DEST_DIR"