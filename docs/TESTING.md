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
| Final | Resumen y actividad FIT visibles tras sincronizar | Pendiente |
| Salida | BACK 4 s cierra; comprobar sesion incompleta | Pendiente |
| Pantalla | Nombres y textos legibles sin recortes | Pendiente |
| Memoria | Sin errores durante una rutina completa | Pendiente |

Para pruebas rapidas usa una rutina corta de prueba con descansos de 1 segundo; no sustituyas el ejemplo publicado por datos personales. En modo mensual comprueba cuatro finalizaciones satisfactorias y un esfuerzo 4-5 intermedio.

La compilacion de esta copia produjo un PRG de 124572 bytes, con 6666 bytes de datos y 12378 bytes de codigo segun el compilador. Estas cifras no miden el pico de memoria durante el entrenamiento. La clave usada para verificarlo permanece fuera de este repositorio; el binario generado esta ignorado por Git.
