using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.FitContributor;
using Toybox.System;

// Crea una actividad FIT para que el entrenamiento se sincronice con Garmin Connect.
// Si un reloj no soporta FIT desde Connect IQ, la app sigue funcionando y solo
// muestra el resumen dentro del reloj.
class WorkoutRecorder {
    const FIELD_TOTAL_WEIGHT = 0;
    const FIELD_SETS = 1;
    const FIELD_REPS = 2;
    const FIELD_EFFORT_AVG = 3;
    const FIELD_REPS_AVG = 4;
    // El id 5 se reserva al antiguo campo "current_exercise". No se reutiliza.
    const FIELD_SESSION_VOLUME = 6;
    const FIRST_EXERCISE_FIELD = 7;
    const EXERCISE_SLOTS = 6;
    const EXERCISE_BYTES = 36;
    const FIELD_EXTRA_EXERCISES = 13;

    private var _session;
    private var _totalWeightField;
    private var _setsField;
    private var _repsField;
    private var _effortAvgField;
    private var _repsAvgField;
    private var _sessionVolumeField;
    private var _exerciseFields;
    private var _extraExercisesField;

    function initialize() {
        clearFields();
    }

    function start(routineName) {
        // No perder una sesion anterior que no se haya podido guardar.
        if (_session != null) {
            return false;
        }
        clearFields();

        if (!(Toybox has :ActivityRecording)) {
            return false;
        }

        try {
            _session = ActivityRecording.createSession({
                :name => routineName,
                :sport => Activity.SPORT_TRAINING,
                :subSport => Activity.SUB_SPORT_STRENGTH_TRAINING
            });

            if (_session != null) {
                // Un campo opcional no debe impedir la grabacion basica.
                try {
                    setupFields();
                } catch (error) {
                    System.println("GymApp: FIT fields: " + error.getErrorMessage());
                }
                if (_session.start()) {
                    return true;
                }
                System.println("GymApp: FIT start returned false");
            }
        } catch (error) {
            System.println("GymApp: FIT start: " + error.getErrorMessage());
        }
        discard();
        return false;
    }

    function update(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName) {
        if (_session == null) {
            return;
        }

        var totalKg = TextTools.tenthsToKg(totalWeightTenths);
        var effortAverage = 0.0;
        var repsAverage = 0.0;

        if (effortCount > 0) {
            effortAverage = effortSum.toFloat() / effortCount.toFloat();
        }

        if (setsDone > 0) {
            repsAverage = repsDone.toFloat() / setsDone.toFloat();
        }

        // Cada campo es opcional. Si uno falla, se intenta guardar el resto
        // y, sobre todo, se conserva la actividad basica.
        setField(_totalWeightField, totalKg);
        setField(_setsField, setsDone);
        setField(_repsField, repsDone);
        setField(_effortAvgField, effortAverage);
        setField(_repsAvgField, repsAverage);
        setField(_sessionVolumeField, totalKg);
    }

    // Los seis ejercicios del dia caben en la contribucion de sesion:
    // 6 x 36 bytes de texto + 20 de totales + 2 de contador = 238 (< 256).
    // Por encima de seis se mantiene todo localmente y se indica cuantas
    // filas no caben; nunca se excede el limite FIT ni se omiten sin avisar.
    function updateExerciseDetails(results) {
        if (_session == null) { return; }
        var extras = 0;
        for (var i = 0; i < results.size(); i++) {
            if (i < _exerciseFields.size()) {
                setField(_exerciseFields[i], exerciseSummary(results[i]));
            } else if (i >= EXERCISE_SLOTS && results[i].setsDone > 0) {
                extras++;
            }
        }
        setField(_extraExercisesField, extras);
    }

    // Solo el nombre puede abreviarse. Series, repeticiones y kilos se
    // conservan completos. ASCII permite respetar exactamente los 36 bytes.
    static function exerciseSummary(result) {
        if (result.setsDone == 0) { return "-"; }
        var suffix = " " + result.setsDone + "x" + result.reps + " " + TextTools.weightLabel(result.weightTenths);
        var available = 35 - suffix.length(); // Un byte reservado al terminador.
        var name = fitName(result.name);
        if (name.length() > available) {
            if (available > 3) {
                name = name.substring(0, available - 3) + "...";
            } else {
                name = "";
            }
        }
        return name + suffix;
    }

    static function fitName(name) {
        var result = "";
        for (var i = 0; i < name.length() && i < 64; i++) {
            var ch = name.substring(i, i + 1);
            if (ch.equals("á") || ch.equals("à")) { ch = "a"; }
            else if (ch.equals("é") || ch.equals("è")) { ch = "e"; }
            else if (ch.equals("í")) { ch = "i"; }
            else if (ch.equals("ó") || ch.equals("ò")) { ch = "o"; }
            else if (ch.equals("ú") || ch.equals("ü")) { ch = "u"; }
            else if (ch.equals("ñ")) { ch = "n"; }
            else if (ch.toCharArray()[0].toNumber() > 127) { ch = "?"; }
            result += ch;
        }
        return result;
    }

    function stopAndSave(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName) {
        update(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName);

        if (_session == null) {
            return false;
        }

        try {
            if (_session.isRecording()) {
                if (!_session.stop()) {
                    System.println("GymApp: FIT stop returned false");
                    return false;
                }
            }

            // Garmin devuelve un Boolean: no dar el guardado por hecho.
            if (_session.save()) {
                clearFields();
                return true;
            }
            System.println("GymApp: FIT save returned false");
        } catch (error) {
            System.println("GymApp: FIT save: " + error.getErrorMessage());
        }
        // Conservar la sesion detenida para poder reintentar, sin duplicarla.
        return false;
    }

    function discard() {
        if (_session != null) {
            try {
                if (_session.isRecording()) {
                    _session.stop();
                }
                _session.discard();
                clearFields();
                return true;
            } catch (error) {
                System.println("GymApp: FIT discard: " + error.getErrorMessage());
                return false;
            }
        }
        return true;
    }

    function hasSession() {
        return _session != null;
    }

    private function setField(field, value) {
        if (field == null) {
            return;
        }
        try {
            field.setData(value);
        } catch (error) {
            System.println("GymApp: FIT field: " + error.getErrorMessage());
        }
    }

    // Solo existe al compilar con -t. Permite simular fallos reales de disco
    // sin llenar el almacenamiento del reloj ni incluir dobles en la app final.
    (:testSupport)
    function useTestSession(session) {
        _session = session;
    }

    (:testSupport)
    function createTestFields() {
        setupFields();
    }

    (:testSupport)
    function getTestExerciseFieldCount() {
        return _exerciseFields.size();
    }

    private function setupFields() {
        if (!(Toybox has :FitContributor)) {
            return;
        }

        _totalWeightField = _session.createField("total_weight", FIELD_TOTAL_WEIGHT, FitContributor.DATA_TYPE_FLOAT, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "kg"
        });
        _setsField = _session.createField("sets_done", FIELD_SETS, FitContributor.DATA_TYPE_UINT16, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "sets"
        });
        _repsField = _session.createField("reps_done", FIELD_REPS, FitContributor.DATA_TYPE_UINT16, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "reps"
        });
        _effortAvgField = _session.createField("effort_avg", FIELD_EFFORT_AVG, FitContributor.DATA_TYPE_FLOAT, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "1-5"
        });
        _repsAvgField = _session.createField("reps_avg", FIELD_REPS_AVG, FitContributor.DATA_TYPE_FLOAT, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "reps"
        });
        _sessionVolumeField = _session.createField("session_volume", FIELD_SESSION_VOLUME, FitContributor.DATA_TYPE_FLOAT, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "kg"
        });
        for (var i = 0; i < EXERCISE_SLOTS; i++) {
            _exerciseFields.add(_session.createField("GymApp ejercicio " + (i + 1), FIRST_EXERCISE_FIELD + i, FitContributor.DATA_TYPE_STRING, {
                :mesgType => FitContributor.MESG_TYPE_SESSION,
                :count => EXERCISE_BYTES,
                :units => ""
            }));
        }
        _extraExercisesField = _session.createField("GymApp ejercicios extra", FIELD_EXTRA_EXERCISES, FitContributor.DATA_TYPE_UINT16, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "ejercicios"
        });
    }

    private function clearFields() {
        _session = null;
        _totalWeightField = null;
        _setsField = null;
        _repsField = null;
        _effortAvgField = null;
        _repsAvgField = null;
        _sessionVolumeField = null;
        _exerciseFields = [];
        _extraExercisesField = null;
    }
}
