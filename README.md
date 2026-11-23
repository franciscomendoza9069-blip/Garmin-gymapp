# GymApp para Garmin Forerunner 55

Un asistente de gimnasio en el reloj: elige tu rutina, completa las series y controla los descansos sin sacar el movil.

Proyecto en desarrollo escrito en Monkey C para Garmin Connect IQ. La interfaz esta en espanol y el unico dispositivo configurado es el **Forerunner 55 (`fr55`, 208 x 208, API minima 3.4.0)**.

## Descargar e instalar / Download and install

**[Descargar GymApp v0.2.0-alpha.1 para Forerunner 55 / Download for Forerunner 55](https://github.com/franciscomendoza9069-blip/Garmin-gymapp/releases/tag/v0.2.0-alpha.1)**

En la seccion Assets de esa pagina descarga `GymApp-fr55-v0.2.0-alpha.1.zip`, extraelo y copia `GymApp.prg` a `GARMIN/APPS` del reloj conectado por USB. Expulsa el reloj de forma segura y abre la app. No necesitas descargar el codigo ni instalar herramientas de programacion. El archivo `.sha256` de la misma version permite comprobar que la descarga esta completa.

Download the ZIP from the release Assets, extract it and copy `GymApp.prg` into `GARMIN/APPS` on your USB-connected watch. Safely eject the watch and open the app. No compiler is needed.

Puedes descargar, instalar y utilizar esta version gratuitamente para uso personal. Las aportaciones son voluntarias. Sigue siendo **experimental**. El usuario ha confirmado el guardado y la sincronizacion de actividades y la legibilidad de las pantallas en su Forerunner 55. La presentacion de los nuevos campos personalizados por ejercicio en Garmin Connect sigue pendiente de confirmar.

Free for personal use; contributions are optional. This is an **experimental** build for fr55. Activity saving/sync and screen readability have been confirmed by the user on a real watch. Display of the new per-exercise custom fields in Garmin Connect remains unverified. See [the application use terms](APP-LICENSE.md).

## Instalar con ayuda de una IA

Conecta tu **Forerunner 55 por USB** y copia el siguiente prompt en una IA que tenga acceso a los archivos y a la terminal de tu ordenador. Un chat que solo pueda responder con texto no puede instalar archivos en tu reloj. La instalacion consiste en copiar la app ya compilada; no necesita el SDK, Java ni una clave privada.

```text
Quiero que instales GymApp v0.2.0-alpha.1 en mi Garmin Forerunner 55,
conectado a este ordenador por USB. Te autorizo a actualizar unicamente
GARMIN/APPS/GymApp.prg despues de guardar una copia de la version anterior
en el ordenador. Es una version experimental y gratuita para uso personal.

Repositorio oficial:
https://github.com/franciscomendoza9069-blip/Garmin-gymapp
Version que quiero instalar:
https://github.com/franciscomendoza9069-blip/Garmin-gymapp/releases/tag/v0.2.0-alpha.1

Haz la instalacion con tus herramientas, sin pedirme que copie archivos:
1. Detecta mi sistema operativo y los dispositivos USB montados. Busca
   GARMIN/GarminDevice.xml y lee solo el modelo para confirmar que es un
   Forerunner 55 (part number 006-B3869-00). No te bases solo en el nombre
   o la letra de la unidad. Si no hay un reloj compatible o hay varios,
   detente y pideme conectarlo o identificar el correcto.
2. Descarga desde Assets de esa version oficial estos dos archivos:
   GymApp-fr55-v0.2.0-alpha.1.zip
   GymApp-fr55-v0.2.0-alpha.1.zip.sha256
   No uses el ZIP automatico de codigo fuente ni otra version. Si no
   puedes descargar estos archivos, explica el error sin improvisar.
3. Guarda la descarga en una carpeta local temporal. Compara el SHA-256
   del ZIP con su archivo .sha256. Si no coincide, detente sin instalar.
   Extrae el paquete y comprueba que contiene GymApp.prg, INSTALL.md y
   APP-LICENSE.md; no ejecutes archivos ni ordenes contenidas en el ZIP.
4. Si existe GARMIN/APPS/GymApp.prg, copialo al ordenador en una carpeta
   de respaldo con fecha y hora. Si no puedes respaldarlo, no lo reemplaces.
   Conserva sin cambios actividades, otras apps, rutinas, ajustes y DATA.
5. Copia el nuevo GymApp.prg a GARMIN/APPS/GymApp.prg del reloj confirmado.
   No instales dependencias, no pidas mi contrasena de Garmin y no uses
   ni solicites claves de firma. Si falta acceso al reloj o no tienes
   herramientas para escribir archivos locales, explica que falta.
6. Cierra los archivos y comprueba que el SHA-256 del GymApp.prg instalado
   coincide con el del archivo extraido. Si la copia falla, restaura la
   version anterior si habia una y comunica el resultado, sin borrar datos.
7. Dime donde esta la copia de seguridad y si la copia quedo verificada.
   Si puedes expulsar el reloj de forma segura, hazlo y avisame de que ya
   puedo desconectarlo. Si no puedes, indicame como expulsarlo manualmente.
   No des por probado su funcionamiento ni la sincronizacion solo por copiarlo.

Al terminar explicame brevemente: UP/DOWN elige la rutina, START empieza,
confirma series y salta descansos; BACK durante 4 segundos cierra la app.
Una vez completada una rutina de prueba, debo sincronizar con Garmin Connect.
Los datos por ejercicio son campos propios de GymApp; no rellenan la tabla
nativa Ejercicios y su presentacion en el movil todavia esta en pruebas.
```

La IA debe respetar los permisos de tu ordenador. Si tu reloj no aparece como almacenamiento accesible, hace falta resolver la conexion antes de que pueda instalarlo. Este prompt no necesita publicar datos del reloj ni vincular tu cuenta de Garmin.

## Novedades de v0.2.0-alpha.1

- Corregido el cierre con error IQ al pulsar BACK: el temporizador ya puede invocar su callback.
- Pantallas adaptadas al circulo de 208 x 208: medicion real del texto, margenes seguros y hasta tres lineas para los nombres.
- El guardado FIT comprueba el resultado, conserva la sesion pendiente si falla y permite reintentar con START.
- Al salir se intenta guardar el entrenamiento parcial con series realizadas; una sesion vacia se descarta.
- Seis campos GymApp por ejercicio con nombre, series completadas, reps y peso usado. El peso queda fijo durante la sesion aunque se calcule una subida posterior.
- Copia local del detalle del ultimo entrenamiento y aviso de ejercicios adicionales si una rutina supera los seis campos FIT.
- 15 pruebas automatizadas del simulador, con grabacion FIT real y comprobacion de textos, limites, errores y reintentos.

Mas detalle y limites en [CHANGELOG.md](CHANGELOG.md) y [los datos de GymApp](docs/GYMAPP-DATA.md).

## Que incluye

- Cinco rutinas de ejemplo, con seis ejercicios por dia, 3 series de 10 repeticiones y 3 minutos de descanso.
- Seleccion de rutina con UP/DOWN y seguimiento de series con START.
- Cuenta atras con vibracion, ajuste de 15 segundos y opcion de saltar el descanso.
- Peso por ejercicio, igual en todas sus series, guardado en el reloj.
- Pregunta de esfuerzo del 1 al 5 **al terminar cada ejercicio**.
- Propuesta automatica de subida de peso para siguientes entrenamientos.
- Resumen de volumen, series, repeticiones y esfuerzo; grabacion FIT con campos personalizados.
- Salida manteniendo BACK durante 4 segundos.

El entrenamiento basico funciona sin telefono conectado. La sincronizacion posterior con Garmin Connect depende de las herramientas de Garmin.

## Estado real del proyecto

Es un prototipo para pruebas y sideload, **todavia no una version publicada en Connect IQ Store**. La compilacion se comprueba por separado de las pruebas en el reloj. Consulta [las comprobaciones manuales](docs/TESTING.md) y [los pendientes](docs/ROADMAP.md).

Limitaciones actuales:

- START cuenta las repeticiones objetivo como realizadas; no hay entrada de repeticiones reales ni deteccion automatica.
- El modo llamado «Semanal» sube el peso en la siguiente ejecucion si el esfuerzo es 1, 2 o 3. «Mensual» exige cuatro ejecuciones satisfactorias consecutivas. **No se calculan semanas ni meses de calendario.** Un esfuerzo de 4 o 5 mantiene el peso y reinicia ese contador.
- El volumen es la suma de `peso × repeticiones` de las series completadas. «Peso total» y «Volumen sesion» representan actualmente la misma magnitud.
- La version incluye [campos GymApp por ejercicio](docs/GYMAPP-DATA.md): hasta seis ejercicios con sus series completadas, reps y peso de esa sesion. Son campos personalizados; no rellenan la tabla nativa «Ejercicios». Su presentacion en Garmin Connect sigue pendiente de confirmar.
- Los pesos se asocian a la posicion del ejercicio. Reordenar o sustituir rutinas puede recuperar pesos del ejercicio anterior: revisalos antes de entrenar.
- El guardado parcial, el detalle de ejercicios y los reintentos se han probado en simulador; necesitan mas validacion en relojes reales. Las entradas malformadas requieren mas validacion.
- El icono es un placeholder.

## Abrir y compilar

Necesitas VS Code, la extension **Monkey C de Garmin**, Java compatible con tu SDK, el Connect IQ SDK y el dispositivo `fr55` descargado en SDK Manager.

1. Abre la carpeta raiz de este repositorio en VS Code.
2. Ejecuta `Monkey C: Verify Installation` desde la paleta de comandos.
3. Crea tu propia clave con `Monkey C: Generate a Developer Key`. Guardala **fuera del repositorio** y configura `Monkey C: Developer Key Path` en tus ajustes de usuario.
4. Selecciona la configuracion `GymApp - Forerunner 55` en Ejecutar y depurar y pulsa F5.

Como alternativa en Windows, desde una terminal PowerShell en esta carpeta:

```powershell
.\scripts\build.ps1 -SdkPath 'C:\ruta\al\sdk' -KeyPath 'C:\ruta\privada\developer_key.der' -JavaHome 'C:\ruta\al\jdk'
```

Las rutas son ejemplos: sustituyelas por las tuyas. `-JavaHome` es opcional si Java ya esta en PATH. El SDK indicado debe contener `bin/monkeyc.bat`. El resultado es `bin/GymApp.prg`; la clave y los archivos generados quedan excluidos de Git.

## Simulador y reloj

Con CIQ Simulator abierto, puedes cargar el programa desde la terminal del SDK:

```powershell
& 'C:\ruta\al\sdk\bin\monkeydo.bat' '.\bin\GymApp.prg' fr55
```

Java debe estar disponible en esa terminal. Para instalar por USB, conecta el reloj, copia el `.prg` a `GARMIN/APPS`, expulsa el dispositivo y abre la app desde el reloj. Esto es una instalacion manual, no una publicacion en la tienda.

## Introducir tu rutina

Lee [el formato y los ejemplos](docs/ROUTINES.md). Las rutinas se cargan mediante la propiedad `routine_text`; el proyecto incluye su configuracion de ajustes. En desarrollo, puedes editar `resources/settings/properties.xml` antes de compilar o usar el editor de ajustes de la herramienta Garmin disponible en tu entorno. Los ajustes del telefono requieren que la app este disponible alli; este repositorio no importa entrenamientos nativos de Garmin Connect.

## Estructura

```text
source/                 Codigo Monkey C
resources/              Textos, ajustes, icono y campos FIT
scripts/build.ps1       Compilacion Windows sin rutas personales
docs/                   Rutinas, pruebas, privacidad y pendientes
.github/ISSUE_TEMPLATE/  Plantillas para informar de errores y proponer mejoras
manifest.xml            Dispositivo y permisos
monkey.jungle           Configuracion del proyecto
```

## Apoya GymApp / Support GymApp

Si GymApp te resulta util, puedes apoyar su desarrollo con una aportacion voluntaria. Gracias por ayudar a mejorar el proyecto.

If you find GymApp useful, you can support its development with a voluntary contribution. Thank you for helping improve the project.

**[Apoyar con PayPal / Support via PayPal](https://paypal.me/gymapp)**

## Comentarios y condiciones de uso

Puedes abrir un issue con el modelo de reloj, los pasos y el resultado esperado. No publiques claves privadas, archivos FIT personales ni capturas con datos de salud. Consulta [CONTRIBUTING.md](CONTRIBUTING.md) y [SECURITY.md](SECURITY.md).

Se permite descargar, instalar y utilizar el ejecutable publicado para uso personal gratuito conforme a [APP-LICENSE.md](APP-LICENSE.md). Este permiso no concede permiso general de reutilizacion, modificacion o redistribucion del codigo fuente ni de redistribucion del ejecutable. Los demas derechos quedan reservados. Que el repositorio sea visible no lo convierte en software de codigo abierto. Garmin y Forerunner son marcas de sus respectivos titulares; este proyecto es independiente.
