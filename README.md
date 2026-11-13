# GymApp para Garmin Forerunner 55

Un asistente de gimnasio en el reloj: elige tu rutina, completa las series y controla los descansos sin sacar el movil.

Proyecto en desarrollo escrito en Monkey C para Garmin Connect IQ. La interfaz esta en espanol y el unico dispositivo configurado es el **Forerunner 55 (`fr55`, 208 x 208, API minima 3.4.0)**.

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
- FIT incluye un resumen de sesion y el ultimo ejercicio; no un historial detallado de cada ejercicio ni las tablas nativas de fuerza de Garmin.
- Los pesos se asocian a la posicion del ejercicio. Reordenar o sustituir rutinas puede recuperar pesos del ejercicio anterior: revisalos antes de entrenar.
- El guardado al abandonar un entrenamiento incompleto, los nombres largos y las entradas malformadas requieren mas pruebas y mejoras.
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

No se concede por ahora una licencia de reutilizacion o distribucion del codigo; los derechos quedan reservados mientras se decide el modelo del proyecto. Que el repositorio sea visible no lo convierte en software de codigo abierto. Garmin y Forerunner son marcas de sus respectivos titulares; este proyecto es independiente.
