using Toybox.Test;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Lang;

// Rutina corta para comprobar totales y pantalla final. La grabacion nativa
// completa se comprueba en sixExercisesWithRealFitRecording, una vez por suite.
(:test)
function finishWorkoutSavesFit(logger) {
    var routine = new Routine("GymApp test", [
        new Exercise("Test press", 2, 10, 100, 1, 0),
        new Exercise("Test row", 1, 8, 200, 1, 0)
    ]);
    var machine = new WorkoutStateMachine([routine]);
    machine.useTestRecorder(new TestRecorder(new TestFitSession()));
    logger.debug("Start recording");
    machine.handleSelect();
    machine.handleSelect();
    machine.handleSelect(); // Saltar descanso.
    machine.handleSelect(); // Ultima serie del primer ejercicio.
    machine.handleSelect(); // Confirmar esfuerzo.
    machine.handleSelect(); // Saltar transicion.
    machine.handleSelect(); // Serie del ultimo ejercicio.
    logger.debug("Finish recording");
    machine.handleSelect(); // Esfuerzo final y guardado FIT.
    Test.assertEqual(machine.getState(), 4);
    Test.assertEqual(machine.getSetsDone(), 3);
    Test.assertEqual(machine.getRepsDone(), 28);
    Test.assertEqual(machine.getTotalWeightText(), "360kg");
    Test.assertEqual(machine.getRecordingText(), "FIT guardado");
    var bitmap = new Graphics.BufferedBitmap({:width => 208, :height => 208,
        :palette => [Graphics.COLOR_BLACK, Graphics.COLOR_WHITE]});
    new GymAppView(machine).onUpdate(bitmap.getDc());
    logger.debug("Saved: " + machine.getRecordingText());
    return true;
}

(:test)
class TestBackKeyEvent {
    function getKey() { return WatchUi.KEY_ESC; }
}

(:test)
function backButtonDoesNotCrash(logger) {
    var machine = new WorkoutStateMachine([
        new Routine("Back test", [new Exercise("Test", 1, 1, 0, 1, 0)])
    ]);
    var delegate = new GymAppInputDelegate(machine);
    logger.debug("Press BACK");
    delegate.onKeyPressed(new TestBackKeyEvent());
    delegate.onKeyReleased(new TestBackKeyEvent());
    return true;
}

// Doble de la sesion nativa para comprobar errores y reintentos sin provocar
// fallos de disco en el dispositivo. No se incluye en la app distribuida.
(:test)
class TestFitSession {
    var recording = true;
    var saves = 0;
    var stops = 0;
    var discards = 0;
    var failSave = false;
    var throwOnSave = false;
    var failStop = false;
    function isRecording() { return recording; }
    function stop() {
        stops++;
        if (failStop) { return false; }
        recording = false;
        return true;
    }
    function save() {
        saves++;
        if (throwOnSave) { throw new Lang.Exception(); }
        return !failSave;
    }
    function discard() { discards++; recording = false; }
}

(:test)
class TestRecorder extends WorkoutRecorder {
    function initialize(session) {
        WorkoutRecorder.initialize();
        useTestSession(session);
    }
    function start(name) { return true; }
}

(:test)
function fitSaveFailureCanRetry(logger) {
    var session = new TestFitSession();
    session.failSave = true;
    var machine = new WorkoutStateMachine([
        new Routine("Failure test", [new Exercise("Test", 1, 10, 100, 1, 0)])
    ]);
    machine.useTestRecorder(new TestRecorder(session));
    machine.handleSelect(); // Empezar.
    machine.handleSelect(); // Completar serie.
    machine.handleSelect(); // Esfuerzo y primer intento (fallido).
    Test.assertEqual(machine.getRecordingText(), "FIT no guardado");
    Test.assert(machine.canRetrySave());
    machine.handleBack();
    Test.assertEqual(machine.getState(), 4); // No perder la sesion pendiente.
    session.failSave = false;
    machine.handleSelect(); // Reintentar, sin repetir progresion ni totales.
    Test.assertEqual(machine.getRecordingText(), "FIT guardado");
    Test.assertEqual(machine.getSetsDone(), 1);
    Test.assertEqual(session.stops, 1);
    Test.assertEqual(session.saves, 2);
    machine.onExit();
    Test.assertEqual(session.saves, 2); // No guardar una segunda copia.
    return true;
}

(:test)
function fitExceptionDoesNotCrash(logger) {
    var session = new TestFitSession();
    session.throwOnSave = true;
    var recorder = new TestRecorder(session);
    Test.assert(!recorder.stopAndSave(0, 1, 10, 3, 1, "Test"));
    Test.assert(recorder.hasSession());
    session.throwOnSave = false;
    Test.assert(recorder.stopAndSave(0, 1, 10, 3, 1, "Test"));
    return true;
}

(:test)
function stopFailureDoesNotSave(logger) {
    var session = new TestFitSession();
    session.failStop = true;
    var recorder = new TestRecorder(session);
    Test.assert(!recorder.stopAndSave(0, 1, 10, 3, 1, "Test"));
    Test.assertEqual(session.saves, 0);
    session.failStop = false;
    Test.assert(recorder.stopAndSave(0, 1, 10, 3, 1, "Test"));
    return true;
}

(:test)
function exitingSavesPartialWorkout(logger) {
    var session = new TestFitSession();
    var machine = new WorkoutStateMachine([
        new Routine("Exit test", [new Exercise("Test", 2, 10, 100, 1, 0)])
    ]);
    machine.useTestRecorder(new TestRecorder(session));
    machine.handleSelect();
    machine.handleSelect();
    machine.onExit();
    Test.assertEqual(session.saves, 1);
    Test.assertEqual(machine.getRecordingText(), "FIT guardado");
    return true;
}

(:test)
function exitingEmptyWorkoutDiscards(logger) {
    var session = new TestFitSession();
    var machine = new WorkoutStateMachine([
        new Routine("Empty test", [new Exercise("Test", 1, 10, 0, 1, 0)])
    ]);
    machine.useTestRecorder(new TestRecorder(session));
    machine.handleSelect();
    machine.onExit();
    Test.assertEqual(session.saves, 0);
    Test.assertEqual(session.discards, 1);
    return true;
}
