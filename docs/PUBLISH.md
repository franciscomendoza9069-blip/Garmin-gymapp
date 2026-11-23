# Mantener la publicacion de GymApp

Repositorio publico: https://github.com/franciscomendoza9069-blip/Garmin-gymapp

La copia de trabajo debe ser un repositorio independiente. No publiques la carpeta personal original ni su carpeta superior, que contienen otros proyectos y archivos privados.

## Actualizar el codigo

1. Revisa los cambios en Control de codigo fuente de VS Code y confirma que solo incluyen codigo, recursos y documentacion del proyecto.
2. Ejecuta las comprobaciones apropiadas: compilacion para fr55 y pruebas del simulador cuando cambie la app.
3. Crea un commit con tu propia cuenta y subelo al repositorio.
4. Comprueba en GitHub que el README describe el comportamiento real y distingue las pruebas del simulador de las realizadas en reloj.

## Publicar una descarga instalable

1. Compila con tu clave privada guardada fuera del repositorio.
2. Prepara un ZIP que contenga unicamente `GymApp.prg`, `INSTALL.md` y `APP-LICENSE.md`.
3. Calcula el SHA-256 del ZIP y crea un archivo `.sha256` con el hash y el nombre del ZIP.
4. Crea una release asociada al commit correcto, sube ambos archivos y marcala como pre-release mientras sea experimental.
5. Actualiza en el README el enlace de descarga, el nombre del ZIP y las referencias del prompt de instalacion asistida por IA.
6. Comprueba que la descarga publica coincide con el ZIP local. No sustituyas silenciosamente los archivos de una version anterior.

Nunca publiques `developer_key.der`, archivos FIT personales, respaldos del reloj, instaladores o exportaciones de otras webs. El `.gitignore` protege el flujo normal de Git, pero no los archivos que se adjuntan manualmente en una release.

No anuncies la version como estable ni compatible con otros modelos. La app sigue limitada al Forerunner 55 y los campos por ejercicio no rellenan la tabla nativa «Ejercicios» de Garmin Connect.
