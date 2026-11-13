using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.FitContributor;

// Crea una actividad FIT para que el entrenamiento se sincronice con Garmin Connect.
// Si un reloj no soporta FIT desde Connect IQ, la app sigue funcionando y solo
// muestra el resumen dentro del reloj.
class WorkoutRecorder {
    const FIELD_TOTAL_WEIGHT = 0;
    const FIELD_SETS = 1;
    const FIELD_REPS = 2;
    const FIELD_EFFORT_AVG = 3;
    const FIELD_REPS_AVG = 4;
    const FIELD_CURRENT_EXERCISE = 5;
    const FIELD_SESSION_VOLUME = 6;

    private var _session;
    private var _totalWeightField;
    private var _setsField;
    private var _repsField;
    private var _effortAvgField;
    private var _repsAvgField;
    private var _currentExerciseField;
    private var _sessionVolumeField;

    function initialize() {
        clearFields();
    }

    function start(routineName) {
        clearFields();

        if (Toybox has :ActivityRecording) {
            _session = ActivityRecording.createSession({
                :name => routineName,
                :sport => Activity.SPORT_TRAINING,
                :subSport => Activity.SUB_SPORT_STRENGTH_TRAINING
            });

            if (_session != null) {
                setupFields();
                _session.start();
            }
        }
    }

    function update(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName) {
        if (_session == null || _totalWeightField == null) {
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

        _totalWeightField.setData(totalKg);
        _setsField.setData(setsDone);
        _repsField.setData(repsDone);
        _effortAvgField.setData(effortAverage);
        _repsAvgField.setData(repsAverage);
        _currentExerciseField.setData(currentExerciseName);
        _sessionVolumeField.setData(totalKg);
    }

    function stopAndSave(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName) {
        update(totalWeightTenths, setsDone, repsDone, effortSum, effortCount, currentExerciseName);

        if (_session != null) {
            if (_session.isRecording()) {
                _session.stop();
            }

            _session.save();
            _session = null;
        }
    }

    function discard() {
        if (_session != null) {
            _session.discard();
            _session = null;
        }
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
        _currentExerciseField = _session.createField("current_exercise", FIELD_CURRENT_EXERCISE, FitContributor.DATA_TYPE_STRING, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :count => 64,
            :units => "txt"
        });
        _sessionVolumeField = _session.createField("session_volume", FIELD_SESSION_VOLUME, FitContributor.DATA_TYPE_FLOAT, {
            :mesgType => FitContributor.MESG_TYPE_SESSION,
            :units => "kg"
        });
    }

    private function clearFields() {
        _session = null;
        _totalWeightField = null;
        _setsField = null;
        _repsField = null;
        _effortAvgField = null;
        _repsAvgField = null;
        _currentExerciseField = null;
        _sessionVolumeField = null;
    }
}
