# Publicar esta copia en GitHub

Esta carpeta es un repositorio independiente preparado para publicar. No esta conectado a ninguna cuenta ni se ha subido nada. Tampoco se ha creado un commit con una identidad inventada: usa tu propia cuenta al publicarlo.

## Desde VS Code

1. Abre **esta carpeta limpia**, no el proyecto original ni su carpeta superior.
2. En Control de codigo fuente, revisa los archivos y crea el primer commit con el mensaje `Preparar prototipo GymApp para GitHub`.
3. Si Git pide tu identidad, configura tu nombre y el correo privado de GitHub que aparece en los ajustes de tu cuenta, o el correo que decidas hacer publico.
4. Pulsa **Publicar en GitHub** e inicia sesion. Usa el nombre `gymapp` o `gymapp-garmin`.
5. Elige privado si quieres revisar primero; elige publico cuando quieras mostrar el codigo.
6. Comprueba en GitHub que aparecen README, source y resources, y que no aparece ninguna clave privada ni archivo de otra web.

Descripcion sugerida:

> Asistente de gimnasio para Garmin Forerunner 55: rutinas, series, descansos con vibracion y esfuerzo por ejercicio. Prototipo en Monkey C.

Temas sugeridos: `garmin`, `connect-iq`, `monkey-c`, `forerunner-55`, `fitness`, `strength-training`.

No elijas una licencia permisiva automaticamente: todavia no se ha decidido si se permite reutilizar y redistribuir el codigo. Puedes mantener el repositorio privado hasta decidirlo. No anuncies una version estable ni compatibilidad con otros dispositivos.

## Sobre el ZIP limpio

El ZIP de entrega contiene solo los archivos previstos para el repositorio, sin `.git`, claves ni binarios de compilacion. Si lo extraes en otra carpeta, tendras que inicializar alli el repositorio al publicarlo. Es preferible usar la carpeta limpia ya preparada.

El `.gitignore` protege el flujo normal de Git, pero no filtra archivos arrastrados manualmente a la web de GitHub. No subas la carpeta original por ese metodo.
