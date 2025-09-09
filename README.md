# Cómo usar el script dim.sh
1. **Clona el repositorio**
`git clone <url-del-repositorio>`

2. **Copia el archivo** dim.sh
Coloca dim.sh en la raíz del repositorio, al mismo nivel que la carpeta .git.

3. **Actualiza el repositorio**
Si deseas que el script actualice el repositorio antes de ejecutarse, descomenta la línea git pull en el script.

4. **(Opcional) Da permisos de ejecución al script**
`chmod +x dim.sh`

5. **Ejecuta el script y sigue las instrucciones**
`./dim.sh`

## Notas:

- El script te permitirá cambiar de rama si lo deseas.
- Los archivos encontrados se copiarán en la ruta indicada en la variable DEST_DIR.
- Revisa los mensajes informativos en la terminal para seguir el proceso.
