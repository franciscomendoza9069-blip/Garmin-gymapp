# Datos de ejercicios de GymApp - v0.2.0-alpha.1

Esta version agrega campos personalizados al resumen FIT de una sesion. No rellena la tabla nativa «Ejercicios» de Garmin Connect. La sincronizacion usa el procedimiento habitual del reloj, sin herramienta USB ni servidor adicional para transferir los entrenamientos.

## Datos previstos

| Campo | Ejemplo de valor |
| --- | --- |
| GymApp - Ejercicio 1 | Press banca 3x10 20kg |
| GymApp - Ejercicio 2 | Cruce polea 3x10 15kg |
| GymApp - Ejercicio 3 | Press militar 3x10 30kg |
| GymApp - Ejercicios adicionales | 0 |

Los ejemplos ilustran el contenido, no garantizan el aspecto ni la ubicacion en Garmin Connect. Garmin controla esa presentacion, y los metadatos de una app instalada por USB pueden mostrarse de forma distinta a los de una app publicada en la tienda. Hay que probarlo con la cuenta y el reloj reales.

- Hasta seis ejercicios por actividad, suficientes para las cinco rutinas incluidas.
- Solo se cuentan las series que se han marcado como hechas. Las repeticiones siguen siendo las reps objetivo, no medidas por el reloj.
- El peso queda congelado al empezar la sesion. Una subida propuesta para el proximo entrenamiento no modifica el registro del actual.
- Una salida anticipada guarda el detalle parcial. Si se deshace una serie, tambien se corrige ese detalle.
- Los nombres largos se abrevian para conservar completos los numeros. El texto FIT usa caracteres ASCII; el nombre completo se conserva localmente.
- Si hay mas de seis ejercicios, se indica cuantos ejercicios completados adicionales no caben en los campos FIT. Sus detalles si se conservan localmente.

El ultimo entrenamiento conserva una copia simple bajo `last_routine` y `last_exercises` en Application.Storage del reloj, junto con los totales. No es un historial ni incluye por ahora una pantalla para consultarlo: es una copia del ultimo entrenamiento. No se sube a un servidor propio.

## Limite de memoria FIT

Los campos de una sesion suman 238 bytes: 216 de texto (seis slots de 36 bytes, incluido su terminador), 20 de totales y 2 de contador de ejercicios adicionales. Quedan por debajo del limite de 256 bytes de Connect IQ. No se reutiliza el identificador del antiguo campo de ultimo ejercicio.

## Prueba en reloj

1. Instalar v0.2.0-alpha.1. La version anterior v0.1.0-alpha.1 no contiene esta funcion.
2. Completar una rutina de prueba, saltando los descansos si se desea.
3. Confirmar el esfuerzo del ultimo ejercicio y comprobar «FIT guardado».
4. Sincronizar con Garmin Connect y buscar los campos GymApp en el resumen o las estadisticas de la actividad.
5. Comparar nombre, series y pesos con lo mostrado en el reloj. Si no aparecen, conservar la actividad y traer el reloj para inspeccionar el archivo FIT. Que falten en la interfaz no demuestra que falten en el archivo.

La tabla nativa «Ejercicios» puede seguir vacia: no es la ubicacion de estos campos.
