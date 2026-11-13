using Toybox.Application.Properties;
using Toybox.Lang;

// Datos pequenos: pensados para el limite de memoria del Forerunner 55.
// La app intenta leer la rutina desde los ajustes de Connect IQ. Si no puede,
// usa la rutina fija de ejemplo que hay al final del archivo.

class Exercise {
    var name;
    var sets;
    var reps;
    var restSeconds;
    var weightTenths;
    var incrementTenths;

    // weightTenths: kilos x10. Ejemplo: 24.5 kg se guarda como 245.
    // incrementTenths: subida de peso x10. Ejemplo: 2.5 kg se guarda como 25.
    function initialize(nameValue, setsValue, repsValue, weightTenthsValue, restSecondsValue, incrementTenthsValue) {
        name = nameValue;
        sets = setsValue;
        reps = repsValue;
        weightTenths = weightTenthsValue;
        restSeconds = restSecondsValue;
        incrementTenths = incrementTenthsValue;
    }
}

class Routine {
    var name;
    var exercises;

    function initialize(nameValue, exercisesValue) {
        name = nameValue;
        exercises = exercisesValue;
    }
}

class RoutineFactory {
    const ROUTINE_TEXT_KEY = "routine_text";

    static function createRoutines() {
        var text = Properties.getValue("routine_text");

        // Si el usuario pega una rutina en ajustes, usamos esa.
        if (text != null && text.length() > 0) {
            var parsed = RoutineParser.parseRoutines(text);
            if (parsed.size() > 0) {
                return parsed;
            }
        }

        // Fallback para que la app nunca se quede vacia.
        return createDefaultRoutines();
    }

    // Compatibilidad: si algun codigo pide una sola rutina, devolvemos la primera.
    static function createRoutine() {
        return createRoutines()[0];
    }

    static function createDefaultRoutines() {
        /*
            EDITA AQUI SI QUIERES HACERLO A MANO EN CODIGO.

            Formato:
            new Exercise("Nombre", series, reps, pesoKgX10, descansoSeg, subidaKgX10)

            Ejemplo:
            new Exercise("Press banca", 3, 10, 400, 180, 25)
            significa 3x10 con 40.0 kg, 180 s de descanso y subida de 2.5 kg.
        */
        return [
            new Routine("Lunes - Push", [
                new Exercise("Press incl manc", 3, 10, 0, 180, 25),
                new Exercise("Cruce polea bajo", 3, 10, 0, 180, 25),
                new Exercise("Elev laterales", 3, 10, 0, 180, 25),
                new Exercise("Press militar", 3, 10, 0, 180, 25),
                new Exercise("Triceps polea", 3, 10, 0, 180, 25),
                new Exercise("Fondos maquina", 3, 10, 0, 180, 25)
            ]),

            new Routine("Martes - Pull", [
                new Exercise("Remo barra", 3, 10, 0, 180, 25),
                new Exercise("Jalon pecho", 3, 10, 0, 180, 25),
                new Exercise("Pajaro manc", 3, 10, 0, 180, 25),
                new Exercise("Facepull polea", 3, 10, 0, 180, 25),
                new Exercise("Curl barra", 3, 10, 0, 180, 25),
                new Exercise("Curl martillo", 3, 10, 0, 180, 25)
            ]),

            new Routine("Mierc - Pierna", [
                new Exercise("Extension quad", 3, 10, 0, 180, 25),
                new Exercise("Hack o prensa", 3, 10, 0, 180, 25),
                new Exercise("Curl femoral", 3, 10, 0, 180, 25),
                new Exercise("Peso muerto rum", 3, 10, 0, 180, 25),
                new Exercise("Aductores maq", 3, 10, 0, 180, 25),
                new Exercise("Gemelos de pie", 3, 10, 0, 180, 25)
            ]),

            new Routine("Jueves - Push B", [
                new Exercise("Press banca", 3, 10, 0, 180, 25),
                new Exercise("Peck deck", 3, 10, 0, 180, 25),
                new Exercise("Laterales polea", 3, 10, 0, 180, 25),
                new Exercise("Landmine uni", 3, 10, 0, 180, 25),
                new Exercise("Press frances Z", 3, 10, 0, 180, 25),
                new Exercise("Triceps nuca", 3, 10, 0, 180, 25)
            ]),

            new Routine("Viernes - Full", [
                new Exercise("Sentadilla barra", 3, 10, 0, 180, 25),
                new Exercise("Bulgara manc", 3, 10, 0, 180, 25),
                new Exercise("Peso muerto", 3, 10, 0, 180, 25),
                new Exercise("Remo Gironda", 3, 10, 0, 180, 25),
                new Exercise("Aductores maq", 3, 10, 0, 180, 25),
                new Exercise("Gemelos sentado", 3, 10, 0, 180, 25)
            ])
        ];
    }
}

class RoutineParser {
    // Formato de importacion:
    // Rutina|Ejercicio;series;reps;pesoKg;descansoSeg;subidaKg|Ejercicio...
    // Para varios dias/rutinas, separa cada rutina con #.
    static function parseRoutines(text) {
        var routines = [];
        var routineTexts = TextTools.split(text, "#");

        for (var i = 0; i < routineTexts.size(); i++) {
            var routineText = TextTools.trim(routineTexts[i]);
            if (routineText.length() == 0) {
                continue;
            }

            var parts = TextTools.split(routineText, "|");
            if (parts.size() < 2) {
                continue;
            }

            var routineName = TextTools.trim(parts[0]);
            var exercises = [];

            for (var j = 1; j < parts.size(); j++) {
                var exercise = parseExercise(parts[j]);
                if (exercise != null) {
                    exercises.add(exercise);
                }
            }

            if (routineName.length() > 0 && exercises.size() > 0) {
                routines.add(new Routine(routineName, exercises));
            }
        }

        return routines;
    }

    static function parseExercise(text) {
        var fields = TextTools.split(TextTools.trim(text), ";");
        if (fields.size() < 5) {
            return null;
        }

        var name = TextTools.trim(fields[0]);
        var sets = TextTools.safeNumber(fields[1], 3);
        var reps = TextTools.safeNumber(fields[2], 10);
        var weightTenths = TextTools.safeWeightTenths(fields[3], 0);
        var restSeconds = TextTools.safeNumber(fields[4], 180);
        var incrementTenths = 25;

        if (fields.size() >= 6) {
            incrementTenths = TextTools.safeWeightTenths(fields[5], 25);
        }

        if (name.length() == 0 || sets <= 0 || reps <= 0) {
            return null;
        }

        if (restSeconds < 0) {
            restSeconds = 0;
        }

        if (incrementTenths < 0) {
            incrementTenths = 0;
        }

        return new Exercise(name, sets, reps, weightTenths, restSeconds, incrementTenths);
    }
}

class TextTools {
    static function split(text, delimiter) {
        var result = [];
        var start = 0;
        var delimiterLength = delimiter.length();

        while (start <= text.length()) {
            var rest = text.substring(start, text.length());
            var index = rest.find(delimiter);

            if (index == null) {
                result.add(rest);
                break;
            }

            result.add(text.substring(start, start + index));
            start = start + index + delimiterLength;
        }

        return result;
    }

    static function trim(text) {
        var start = 0;
        var finish = text.length();

        while (start < finish && isBlank(text.substring(start, start + 1))) {
            start++;
        }

        while (finish > start && isBlank(text.substring(finish - 1, finish))) {
            finish--;
        }

        return text.substring(start, finish);
    }

    static function safeNumber(text, fallback) {
        var value = trim(text).toNumber();
        if (value == null) {
            return fallback;
        }
        return value;
    }

    static function safeWeightTenths(text, fallback) {
        var value = trim(text).toFloat();
        if (value == null) {
            return fallback;
        }

        var tenths = ((value * 10.0) + 0.5).toNumber();
        if (tenths < 0) {
            return 0;
        }

        return tenths;
    }

    static function weightLabel(tenths) {
        var whole = tenths / 10;
        var decimal = tenths % 10;

        if (decimal == 0) {
            return whole + "kg";
        }

        return whole + "." + decimal + "kg";
    }

    static function tenthsToKg(tenths) {
        return tenths.toFloat() / 10.0;
    }

    static function isBlank(character) {
        return character.equals(" ")
            || character.equals("\n")
            || character.equals("\r")
            || character.equals("\t");
    }
}
