using Toybox.Application.Properties;
using Toybox.Application.Storage;
using Toybox.Attention;

// Toda la logica del entrenamiento vive aqui.
// La vista solo pregunta "en que estado estamos" y dibuja segun la respuesta.
class WorkoutStateMachine {
    const WORKOUT_STATE_MENU = 0;
    const WORKOUT_STATE_ACTIVE = 1;
    const WORKOUT_STATE_RESTING = 2;
    const WORKOUT_STATE_NEXT_EXERCISE = 3;
    const WORKOUT_STATE_FINISHED = 4;
    const WORKOUT_STATE_EFFORT = 5;

    const PROGRESSION_WEEKLY = 0;
    const PROGRESSION_MONTHLY = 1;
    const PROGRESSION_MODE_KEY = "progression_mode";

    private var _routines;
    private var _routineIndex;
    private var _routine;
    private var _exerciseIndex;
    private var _setIndex;
    private var _state;
    private var _restRemaining;
    private var _restTotal;
    private var _nextExerciseTicks;
    private var _finishVibrated;
    private var _recorder;

    private var _totalWeightTenths;
    private var _setsDone;
    private var _repsDone;
    private var _effortSum;
    private var _effortCount;
    private var _pendingEffort;
    private var _lastProgressText;
    private var _recordingSaved;

    function initialize(routines) {
        _routines = routines;
        _routineIndex = 0;
        _routine = _routines[_routineIndex];
        _recorder = new WorkoutRecorder();
        resetToMenu();
    }

    function resetToMenu() {
        _routine = _routines[_routineIndex];
        _exerciseIndex = 0;
        _setIndex = 1;
        _state = WORKOUT_STATE_MENU;
        _restRemaining = 0;
        _restTotal = 0;
        _nextExerciseTicks = 0;
        _finishVibrated = false;
        resetSessionStats();
    }

    function getState() {
        return _state;
    }

    function getRoutineName() {
        return _routine.name;
    }

    function getRoutinePositionText() {
        return (_routineIndex + 1) + "/" + _routines.size();
    }

    function getCurrentExercise() {
        return _routine.exercises[_exerciseIndex];
    }

    function getCurrentSet() {
        return _setIndex;
    }

    function getCurrentWeightText() {
        return TextTools.weightLabel(getCurrentWeightTenths());
    }

    function getRemainingRestSeconds() {
        return _restRemaining;
    }

    function getRestTotalSeconds() {
        return _restTotal;
    }

    function getPendingEffort() {
        return _pendingEffort;
    }

    function getTotalWeightText() {
        return TextTools.weightLabel(_totalWeightTenths);
    }

    function getSetsDone() {
        return _setsDone;
    }

    function getRepsDone() {
        return _repsDone;
    }

    function getAverageEffortText() {
        if (_effortCount == 0) {
            return "-";
        }

        return (_effortSum.toFloat() / _effortCount.toFloat()).format("%.1f");
    }

    function getAverageRepsText() {
        if (_setsDone == 0) {
            return "-";
        }

        return (_repsDone.toFloat() / _setsDone.toFloat()).format("%.1f");
    }

    function getProgressText() {
        return _lastProgressText;
    }

    function getRecordingText() {
        if (_recordingSaved) {
            return "FIT guardado";
        }

        return "Resumen local";
    }

    function handleSelect() {
        if (_state == WORKOUT_STATE_MENU) {
            startWorkout();
        } else if (_state == WORKOUT_STATE_ACTIVE) {
            finishCurrentSet();
        } else if (_state == WORKOUT_STATE_RESTING) {
            completeRest(false);
        } else if (_state == WORKOUT_STATE_NEXT_EXERCISE) {
            enterActive();
        } else if (_state == WORKOUT_STATE_EFFORT) {
            confirmEffort();
        } else if (_state == WORKOUT_STATE_FINISHED) {
            resetToMenu();
        }
    }

    function handleBack() {
        if (_state == WORKOUT_STATE_ACTIVE) {
            goBackOneSet();
        } else if (_state == WORKOUT_STATE_RESTING) {
            // Back durante descanso cancela el descanso y borra esa serie.
            undoCompletedSet();
            _state = WORKOUT_STATE_ACTIVE;
        } else if (_state == WORKOUT_STATE_EFFORT) {
            // En esfuerzo ya se habia contado la ultima serie. La deshacemos.
            undoCompletedSet();
            _state = WORKOUT_STATE_ACTIVE;
        } else if (_state == WORKOUT_STATE_NEXT_EXERCISE) {
            enterActive();
        } else if (_state == WORKOUT_STATE_FINISHED) {
            resetToMenu();
        }
    }

    function handleUp() {
        if (_state == WORKOUT_STATE_MENU) {
            previousRoutine();
        } else if (_state == WORKOUT_STATE_RESTING) {
            _restRemaining += 15;
            _restTotal = _restRemaining;
        } else if (_state == WORKOUT_STATE_EFFORT) {
            if (_pendingEffort < 5) {
                _pendingEffort++;
            }
        }
    }

    function handleDown() {
        if (_state == WORKOUT_STATE_MENU) {
            nextRoutine();
        } else if (_state == WORKOUT_STATE_RESTING) {
            _restRemaining -= 15;
            if (_restRemaining < 0) {
                _restRemaining = 0;
            }
            _restTotal = _restRemaining;
        } else if (_state == WORKOUT_STATE_EFFORT) {
            if (_pendingEffort > 1) {
                _pendingEffort--;
            }
        }
    }

    // Se llama una vez por segundo desde GymAppView.
    function tick() {
        if (_state == WORKOUT_STATE_RESTING) {
            if (_restRemaining > 0) {
                _restRemaining--;
            }

            if (_restRemaining <= 0) {
                completeRest(true);
            }
        } else if (_state == WORKOUT_STATE_NEXT_EXERCISE) {
            _nextExerciseTicks--;
            if (_nextExerciseTicks <= 0) {
                enterActive();
            }
        }
    }

    private function previousRoutine() {
        if (_routineIndex > 0) {
            _routineIndex--;
        } else {
            _routineIndex = _routines.size() - 1;
        }
        resetToMenu();
    }

    private function nextRoutine() {
        if (_routineIndex < _routines.size() - 1) {
            _routineIndex++;
        } else {
            _routineIndex = 0;
        }
        resetToMenu();
    }

    private function startWorkout() {
        _exerciseIndex = 0;
        _setIndex = 1;
        resetSessionStats();
        _recorder.start(_routine.name);
        updateFitSummary();
        enterActive();
    }

    private function resetSessionStats() {
        _totalWeightTenths = 0;
        _setsDone = 0;
        _repsDone = 0;
        _effortSum = 0;
        _effortCount = 0;
        _pendingEffort = 3;
        _lastProgressText = "";
        _recordingSaved = false;
    }

    private function enterActive() {
        _state = WORKOUT_STATE_ACTIVE;
        _restRemaining = 0;
        _restTotal = 0;
        _nextExerciseTicks = 0;
    }

    private function finishCurrentSet() {
        addCompletedSet();

        if (_setIndex < getCurrentExercise().sets) {
            var exercise = getCurrentExercise();
            _restRemaining = exercise.restSeconds;
            _restTotal = exercise.restSeconds;
            _state = WORKOUT_STATE_RESTING;
        } else {
            _pendingEffort = 3;
            _state = WORKOUT_STATE_EFFORT;
        }
    }

    private function completeRest(shouldVibrate) {
        if (shouldVibrate) {
            Attention.vibrate(VibePatterns.restDone());
        }

        if (_setIndex < getCurrentExercise().sets) {
            _setIndex++;
            enterActive();
        } else {
            _pendingEffort = 3;
            _state = WORKOUT_STATE_EFFORT;
        }
    }

    private function confirmEffort() {
        _effortSum += _pendingEffort;
        _effortCount++;

        applyProgression();
        updateFitSummary();

        if (_exerciseIndex < _routine.exercises.size() - 1) {
            _exerciseIndex++;
            _setIndex = 1;
            _state = WORKOUT_STATE_NEXT_EXERCISE;
            _nextExerciseTicks = 3;
            Attention.vibrate(VibePatterns.exerciseChange());
        } else {
            finishRoutine();
        }
    }

    private function finishRoutine() {
        _state = WORKOUT_STATE_FINISHED;
        saveLastSummary();
        _recorder.stopAndSave(_totalWeightTenths, _setsDone, _repsDone, _effortSum, _effortCount, getCurrentExercise().name);
        _recordingSaved = true;

        if (!_finishVibrated) {
            _finishVibrated = true;
            Attention.vibrate(VibePatterns.routineDone());
        }
    }

    private function addCompletedSet() {
        var exercise = getCurrentExercise();
        var weightTenths = getCurrentWeightTenths();

        _setsDone++;
        _repsDone += exercise.reps;
        _totalWeightTenths += weightTenths * exercise.reps;
        updateFitSummary();
    }

    private function undoCompletedSet() {
        if (_setsDone <= 0) {
            return;
        }

        var exercise = getCurrentExercise();
        var weightTenths = getCurrentWeightTenths();

        _setsDone--;
        _repsDone -= exercise.reps;
        _totalWeightTenths -= weightTenths * exercise.reps;

        if (_repsDone < 0) {
            _repsDone = 0;
        }

        if (_totalWeightTenths < 0) {
            _totalWeightTenths = 0;
        }

        updateFitSummary();
    }

    private function goBackOneSet() {
        if (_exerciseIndex == 0 && _setIndex == 1) {
            resetToMenu();
            return;
        }

        if (_setIndex > 1) {
            _setIndex--;
            undoCompletedSet();
        }
    }

    private function applyProgression() {
        var exercise = getCurrentExercise();
        var currentWeight = getCurrentWeightTenths();
        var nextWeight = currentWeight;
        var mode = getProgressionMode();

        if (_pendingEffort <= 3 && exercise.incrementTenths > 0) {
            if (mode == PROGRESSION_WEEKLY) {
                nextWeight = currentWeight + exercise.incrementTenths;
                Storage.setValue(weightStorageKey(), nextWeight);
                _lastProgressText = "Prox " + TextTools.weightLabel(nextWeight);
            } else {
                var count = getMonthlySuccessCount() + 1;
                if (count >= 4) {
                    nextWeight = currentWeight + exercise.incrementTenths;
                    Storage.setValue(weightStorageKey(), nextWeight);
                    Storage.setValue(monthlyCountStorageKey(), 0);
                    _lastProgressText = "Prox " + TextTools.weightLabel(nextWeight);
                } else {
                    Storage.setValue(monthlyCountStorageKey(), count);
                    _lastProgressText = "Bien " + count + "/4";
                }
            }
        } else {
            Storage.setValue(monthlyCountStorageKey(), 0);
            _lastProgressText = "Mantener " + TextTools.weightLabel(currentWeight);
        }

        Storage.setValue(lastEffortStorageKey(), _pendingEffort);
    }

    private function getCurrentWeightTenths() {
        var storedWeight = Storage.getValue(weightStorageKey());
        if (storedWeight instanceof Number) {
            return storedWeight;
        }

        return getCurrentExercise().weightTenths;
    }

    private function getMonthlySuccessCount() {
        var count = Storage.getValue(monthlyCountStorageKey());
        if (count instanceof Number) {
            return count;
        }

        return 0;
    }

    private function getProgressionMode() {
        var mode = Properties.getValue(PROGRESSION_MODE_KEY);
        if (mode instanceof Number) {
            return mode;
        }

        return PROGRESSION_WEEKLY;
    }

    private function updateFitSummary() {
        _recorder.update(_totalWeightTenths, _setsDone, _repsDone, _effortSum, _effortCount, getCurrentExercise().name);
    }

    private function saveLastSummary() {
        Storage.setValue("last_volume", _totalWeightTenths);
        Storage.setValue("last_sets", _setsDone);
        Storage.setValue("last_reps", _repsDone);
        Storage.setValue("last_effort_sum", _effortSum);
        Storage.setValue("last_effort_count", _effortCount);
    }

    private function weightStorageKey() {
        return "w" + _routineIndex + "_" + _exerciseIndex;
    }

    private function monthlyCountStorageKey() {
        return "m" + _routineIndex + "_" + _exerciseIndex;
    }

    private function lastEffortStorageKey() {
        return "e" + _routineIndex + "_" + _exerciseIndex;
    }
}
