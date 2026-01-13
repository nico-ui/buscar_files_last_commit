#!/bin/bash

# Función para cambiar de rama
cambiar_rama() {
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
}

# Función para limpiar directorio
limpiar_directorio() {
    local dir="$1"
    # Verificar si el directorio esta vacio
    if [ -z "$(ls -A "$dir")" ]; then
        echo "[INFO] El directorio destino $dir esta vacio."
    else
        echo "[INFO] El directorio destino no esta vacio. Limpiando el directorio..."
        rm -rf "$dir"/{*,.*}
    fi
}

# Función para buscar archivos por nombre
buscar_por_nombre() {
    read -p "[INFO] Indica el nombre o parte del nombre de los archivos a buscar (p.e. lauf*uf15uf1502c*.xml): " nombre_archivo
    if [ "$nombre_archivo" != "" ]
    then
        echo "[INFO] Buscando archivos que contengan '$nombre_archivo' en su nombre..."
        archivos_nuevos=($(find . -type f -iname "*$nombre_archivo*"))
        num_coincidencias=$(find . -type f -iname "*$nombre_archivo*" | wc -l)
        
        echo "[INFO] Numero de archivos encontrados: $num_coincidencias"

        #limpiar_directorio "$DEST_DIR"

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
    else
        echo "[INFO] Nombre de archivo NO valido. Saliendo..."
    fi
}

# Función para buscar archivos por último commit
buscar_por_ultimo_commit() {
    cambiar_rama

    limpiar_directorio "$DEST_DIR"

    echo "[INFO] Buscando archivos .xml, .properties, .xls, .dat y .sh nuevos en el ultimo commit..."
    # Mostrar el ultimo commit
    echo "[INFO] Buscando en el Ultimo commit:"
    git log --oneline -1
    #git log --oneline -4 | tail -n 1

    # Obtener los archivos .xml, .properties, .xls, .sh y .java modificados o añadidos del ultimo commit
    # archivos_nuevos=($(git diff --name-only --diff-filter=MA $(git merge-base HEAD origin/$(git rev-parse --abbrev-ref HEAD)) | grep -E '\.(xml|properties|xls|sh)$'))
    #archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD | grep -E '\.(xml|properties|xls|sh)$'))
    archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD~1..HEAD | grep -E '\.(xml|properties|xls|sh|dat)$'))
    # Para buscar en los últimos 3 commits
    #archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD~2..HEAD | grep -E '\.(xml|properties|xls|sh)$'))
    #archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD~4 | grep -E '\.(xml|properties|xls|sh)$'))

    # Detecta si el último commit es un merge
    # if [ "$(git rev-list --parents -n 1 HEAD | wc -w)" -gt 2 ]; then
    #     echo "[INFO] El último commit es un merge. Buscando archivos modificados entre los padres..."
    #     PARENT1=$(git rev-parse HEAD^0)
    #     echo "[INFO] Padre 1: $PARENT1"
    #     PARENT2=$(git rev-parse HEAD^1)
    #     echo "[INFO] Padre 2: $PARENT2"
    #     archivos_nuevos=($(git diff --name-only --diff-filter=MA $PARENT1 $PARENT2 | grep -E '\.(xml|properties|xls|sh|dat)$'))
    # else
    #     archivos_nuevos=($(git diff-tree --no-commit-id --name-only --diff-filter=MA -r HEAD | grep -E '\.(xml|properties|xls|sh|dat)$'))
    # fi

    # Imprimir el numero de archivos .xml nuevos encontrados
    num_coincidencias=${#archivos_nuevos[@]}
    echo "[INFO] Numero de archivos .xml, .properties, .xls, .dat y .sh nuevos encontrados: $num_coincidencias"
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
}

# Función para mostrar el menú y procesar opciones
mostrar_menu() {
    echo "[INFO] ----------Menu de opciones:----------"
    echo "[INFO] 1) Buscar por ultimo commit (Defecto)"
    echo "[INFO] 2) Buscar por nombre de los archivos"
    echo "[INFO] 3) Limpiar el directorio de destino antes de copiar los archivos (Defecto)"
    echo "[INFO] 4) Salir"
    echo "[INFO] -------------------------------------"
    read -p "[INFO] Indica una opcion (1, 2, 3 o 4): " opcion
}

echo "[INFO] SCRIPT PARA EXTRAER ARCHIVOS MODIFICADOS O AÑADIDOS EN EL ULTIMO COMMIT DE GIT"
echo "[INFO] Actualizando el repositorio local..."
git pull
echo "[INFO] Repositorio actualizado."

#Crear directorio
DEST_DIR="$HOME/Documents/2026/Dimension/Check in/"
mkdir -p "$DEST_DIR"

# Mostrar menú y procesar opciones
mostrar_menu

if [ "$opcion" == "1" ] || [ "$opcion" == "" ]
then
    # Opción 1: Buscar por último commit (por defecto)
    buscar_por_ultimo_commit
fi

if [ "$opcion" == "2" ]
then
    while true; do
        buscar_por_nombre
        echo "[INFO] Deseas realizar otra busqueda por nombre?: "
        read -p "[INFO] Indica tu respuesta (s/n): " resp_busqueda
        if [ "$resp_busqueda" != "s" ]; then
            echo "[INFO] Saliendo..."
            exit 0
        fi
    done
fi

if [ "$opcion" == "3" ]
then
    limpiar_directorio "$DEST_DIR"
    echo "[INFO] Directorio $DEST_DIR limpiado."
    mostrar_menu
fi

if [ "$opcion" == "4" ]
then
    echo "[INFO] Saliendo..."
    exit 0
fi

