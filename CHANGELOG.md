# Cambios de GymApp

## v0.2.0-alpha.1 - 23 de noviembre de 2026

### Corregido

- Cierre con el simbolo IQ al pulsar BACK: el callback del temporizador pasa a ser publico.
- Guardado FIT sin comprobar el resultado. Ahora se muestra el estado real y se conserva una sesion fallida para reintentar.
- Textos junto al borde y saltos de linea que podian cortar nombres o perder una letra.
- Peso registrado alterado por una subida para el siguiente entrenamiento. Ahora el peso de la sesion se captura al comenzar.

### Anadido

- Pantallas con anchos medidos en pixeles, margenes para el circulo y hasta tres lineas para nombres.
- Guardado de sesiones parciales al cerrar y descarte de sesiones vacias.
- Campos personalizados GymApp para seis ejercicios: nombre abreviado si hace falta, series realizadas, reps objetivo y peso.
- Detalle local del ultimo entrenamiento y contador de ejercicios que exceden los seis campos FIT.
- 15 pruebas del simulador y utilidades de prueba excluidas del binario normal.
- Prompt de instalacion asistida por IA en el README, con deteccion de modelo, respaldo y verificacion de la copia.

### Validacion y limites

El usuario ha confirmado el guardado/sincronizacion de actividades y la mejora de legibilidad en su Forerunner 55. La presentacion de los campos por ejercicio en Garmin Connect sigue pendiente. No se rellenan las series nativas de la tabla «Ejercicios». Se mantiene la progresion por sesiones, no por calendario, y la importacion por texto con recompilacion o herramientas de desarrollo.

## v0.1.0-alpha.1

Primera descarga publica experimental para Forerunner 55: rutinas, series, descansos, esfuerzo, progresion inicial y resumen FIT. Uso personal gratuito y aportaciones voluntarias.
