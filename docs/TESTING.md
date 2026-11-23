# Comprobaciones de la beta

Una compilacion correcta no acredita el comportamiento en el reloj. Marca los resultados solo despues de probarlos y apunta dispositivo, SDK y revision del codigo.

| Prueba | Resultado esperado | Estado |
| --- | --- | --- |
| Compilar para fr55 | Generar bin/GymApp.prg | Correcto: SDK 9.2.0, Java 17 |
| Menu | UP/DOWN recorre cinco rutinas | Pendiente |
| Series | START cuenta una serie con las reps objetivo | Pendiente |
| Descanso | 180 s; ajustes de 15 s; nunca negativo; START salta | Pendiente |
| Vibracion | Fin de descanso, cambio y fin distinguibles | Pendiente |
| Esfuerzo | Aparece al acabar el ejercicio; escala 1-5 | Pendiente |
| Progresion | Esfuerzo 1-3 incrementa segun modo; 4-5 mantiene | Pendiente |
| Persistencia | Los pesos sobreviven al cierre y reapertura | Pendiente |
| Retroceso | Deshacer no genera totales incoherentes | Pendiente |
| Final | Actividad FIT visible tras sincronizar | Confirmado por el usuario en reloj real; nuevos campos por ejercicio pendientes |
| Salida | BACK 4 s cierra; comprobar sesion incompleta | Pendiente |
| Pantalla | Nombres y textos legibles sin recortes | Confirmado por el usuario en reloj real; comprobaciones automaticas del circulo pasan |
| Memoria | Sin errores durante una rutina completa | Pendiente |

Para pruebas rapidas usa una rutina corta de prueba con descansos de 1 segundo; no sustituyas el ejemplo publicado por datos personales. En modo mensual comprueba cuatro finalizaciones satisfactorias y un esfuerzo 4-5 intermedio.

La compilacion inicial produjo un PRG de 124572 bytes, con 6666 bytes de datos y 12378 bytes de codigo segun el compilador. Estas cifras no miden el pico de memoria durante el entrenamiento. La clave usada para verificarlo permanece fuera de este repositorio; el binario generado esta ignorado por Git.

## Prueba local de detalle GymApp, 19 de noviembre de 2026

- 15 pruebas del simulador pasan, incluidas las de pantalla, guardado, errores y nuevos campos por ejercicio.
- Una rutina completa de seis ejercicios crea los seis campos personalizados con la API FIT real del simulador y devuelve guardado correcto.
- Se comprueban ademas la salida parcial, deshacer una serie, el peso anterior a la progresion, nombres largos y el aviso para mas de seis ejercicios.
- Los campos personalizados de sesion suman 238 bytes de los 256 disponibles.
- Compilacion para fr55: 7820 bytes de datos, 16665 de codigo, PRG de 134636 bytes. El tamano total del archivo incluye recursos y no equivale a la memoria maxima de ejecucion.
- Esta compilacion se instalo en el reloj el 19 de noviembre. Sigue pendiente confirmar la presentacion de sus campos por ejercicio en Garmin Connect. La confirmacion previa de guardado y legibilidad por el usuario corresponde a la version anterior, sin estos nuevos campos.

Los tests estan en `tests/`, usan `test.jungle` y se compilan con `monkeyc -t`; despues se ejecutan con `monkeydo ... fr55 /t`. Los datos de prueba se generan solo en el simulador y las utilidades de inyeccion quedan excluidas de `monkey.jungle` mediante la anotacion `testSupport`.
