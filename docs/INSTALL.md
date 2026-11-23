# GymApp v0.2.0-alpha.1 - Forerunner 55

## Castellano

1. Extrae el ZIP de la version oficial.
2. Conecta tu Garmin Forerunner 55 al ordenador con un cable USB de datos.
3. Si ya existe `GARMIN/APPS/GymApp.prg`, guarda primero una copia en el ordenador. Copia el nuevo `GymApp.prg` dentro de `GARMIN/APPS`, conservando el nombre. No borres DATA, SETTINGS, otras apps ni actividades.
4. Expulsa el dispositivo de forma segura y desconectalo.
5. Abre la app en el reloj. UP/DOWN elige rutina; START comienza y confirma series. Mantener BACK 4 segundos sale.

Solo Forerunner 55. No es una publicacion en Connect IQ Store. Version experimental: el usuario ha confirmado guardado, sincronizacion basica y legibilidad con las correcciones anteriores. Los campos nuevos por ejercicio y la salida parcial necesitan validacion adicional en reloj y Garmin Connect. Si un guardado falla, aparece el aviso y START permite reintentarlo mientras la sesion siga disponible.

Incluye cinco rutinas de ejemplo con pesos a cero, 3x10 y descansos de 180 segundos. No detecta repeticiones reales: START registra las repeticiones previstas. Los modos semanal y mensual cuentan ejecuciones, no fechas. La progresion no es una recomendacion de carga personalizada.

El ZIP es una version preconfigurada. Para cambiar su rutina antes de instalarla, usa el codigo fuente y recompila siguiendo el README. No se ofrece un editor de ajustes en el telefono para esta descarga manual.

Incluye hasta seis campos personalizados por ejercicio, por ejemplo `Press banca 3x10 20kg`. Buscalos en los datos de la actividad tras sincronizar. No rellenan la tabla nativa «Ejercicios» y su presentacion en Garmin Connect esta pendiente de confirmar. La copia local solo conserva el ultimo entrenamiento, no un historial.

Si recibiste el ZIP de la version oficial, compara su SHA-256 con el archivo `.sha256` antes de instalar. El README del repositorio incluye un prompt para que una IA con acceso a tu ordenador haga la instalacion por ti.

Puedes descargar y usar el ejecutable gratis para uso personal segun `APP-LICENSE.md`. Si quieres apoyar el proyecto: https://paypal.me/gymapp

## English

Extract the official release ZIP. Connect a Forerunner 55 by USB, back up any existing `GARMIN/APPS/GymApp.prg` to your computer, copy the new `GymApp.prg` into that path, safely eject and disconnect the watch, then open the app. Keep app data, settings, activities and other apps unchanged. UP/DOWN selects a routine; START begins and confirms sets. Hold BACK for four seconds to exit.

Forerunner 55 only. Experimental sideload build, not a Connect IQ Store release. The user confirmed basic activity saving/sync and readability with the earlier fixes. Partial-workout handling and the new per-exercise fields need further on-watch validation. START retries a failed save while the pending session is available.

Six custom fields contain exercise name, completed sets, target reps and session weight. They do not populate Garmin Connect's native Exercises table. Display of these fields in Garmin Connect remains unverified. The local copy retains the latest workout only. Verify the release ZIP against its accompanying SHA-256 file. An installation prompt for a computer-enabled AI is available in the repository README.

Five sample routines are included with zero initial weights, 3x10 sets and 180-second rests. START records target reps, not detected actual reps. Progression modes count completed exercise sessions, not calendar weeks or months. This ZIP is preconfigured; customizing it requires editing and rebuilding the source. No phone settings editor is provided for this manual download.

Personal use is free under `APP-LICENSE.md`. Optional support: https://paypal.me/gymapp
