# Formato de rutinas

Cada rutina ocupa una linea logica. Para introducir varios dias usa `#` entre rutinas. El texto completo debe caber en el limite de 3500 caracteres de los ajustes.

```text
Rutina|Ejercicio;series;reps;pesoKg;descansoSeg;subidaKg
```

Ejemplo de dos dias (pegar como una sola linea):

```text
Push|Press banca;3;10;40;180;2.5|Press militar;3;10;25;180;2.5#Pull|Remo barra;3;10;50;180;2.5|Curl barra;3;10;20;180;2.5
```

| Campo | Ejemplo | Significado |
| --- | --- | --- |
| Rutina | Push | Nombre que aparece en el menu |
| Ejercicio | Press banca | Nombre corto para la pantalla |
| Series | 3 | Entero positivo |
| Reps | 10 | Repeticiones objetivo por serie |
| Peso | 40 | Kilogramos; usa punto para decimales |
| Descanso | 180 | Segundos entre series |
| Subida | 2.5 | Incremento si se cumple la regla de esfuerzo; 0 lo desactiva |

No uses `#`, `|` o `;` dentro de los nombres. Usa nombres breves y valores razonables: el parser aun no valida todos los casos extremos. Se almacena el peso con precision de una decima de kilogramo.

Los ejemplos incluyen pesos iniciales de 0: sustituyelos por tus pesos. La app no distingue automaticamente peso por mancuerna, peso total de barra o maquinas; aplica siempre el mismo criterio al introducirlos.

Para cambiar la rutina inicial, edita `resources/settings/properties.xml`. Si no hay una rutina valida en ajustes, el codigo recurre al ejemplo de `source/Routine.mc`. Ajustes previamente guardados por el reloj pueden prevalecer sobre nuevos valores iniciales.

Los pesos se conservan por indice de rutina y ejercicio. Antes de reorganizar las rutinas, ten en cuenta que un peso guardado puede quedar asociado al nuevo ejercicio que ocupe esa posicion. No hay todavia una herramienta de migracion o reinicio de pesos.
