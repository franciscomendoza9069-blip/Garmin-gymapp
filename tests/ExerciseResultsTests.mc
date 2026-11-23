using Toybox.Application.Storage;
using Toybox.Application.Properties;
using Toybox.FitContributor;
using Toybox.Test;

(:test)
class CaptureFitField {
    var data;
    function setData(value) { data = value; }
}

(:test)
class CaptureFitSession extends TestFitSession {
    var fields = {};
    var bytes = 0;
    function createField(name, id, type, options) {
        if (type == FitContributor.DATA_TYPE_STRING) {
            bytes += options[:count];
        } else if (type == FitContributor.DATA_TYPE_UINT16) {
            bytes += 2;
        } else {
            bytes += 4;
        }
        Test.assert(bytes <= 256);
        var field = new CaptureFitField();
        fields[id] = field;
        return field;
    }
}

(:test)
function exerciseDetailsKeepOriginalWeight(logger) {
    // Modifica solo el almacenamiento del simulador y lo restaura al terminar.
    var oldWeight = Storage.getValue("w0_0");
    var oldMode = Properties.getValue("progression_mode");
    Storage.setValue("w0_0", 200);
    Properties.setValue("progression_mode", 0);
    var session = new CaptureFitSession();
    var recorder = new TestRecorder(session);
    recorder.createTestFields();
    Test.assertEqual(session.bytes, 238);
    var machine = new WorkoutStateMachine([
        new Routine("Weight test", [new Exercise("Press banca", 3, 10, 0, 1, 25)])
    ]);
    machine.useTestRecorder(recorder);
    machine.handleSelect();
    machine.handleSelect(); // Primera serie.
    Test.assertEqual(session.fields[7].data, "Press banca 1x10 20kg");
    machine.handleBack(); // Deshacer durante descanso.
    Test.assertEqual(session.fields[7].data, "-");
    machine.handleSelect();
    machine.handleSelect();
    machine.handleSelect();
    machine.handleSelect();
    machine.handleSelect();
    machine.handleSelect(); // Esfuerzo: sube el peso de la proxima sesion.
    var actual = session.fields[7].data;
    var next = Storage.getValue("w0_0");
    var rows = Storage.getValue("last_exercises");
    if (oldWeight == null) { Storage.deleteValue("w0_0"); }
    else { Storage.setValue("w0_0", oldWeight); }
    Properties.setValue("progression_mode", oldMode);
    Test.assertEqual(actual, "Press banca 3x10 20kg");
    Test.assertEqual(next, 225);
    Test.assertEqual(rows[0][1], 3);
    Test.assertEqual(rows[0][3], 200);
    Test.assertEqual(rows[0][4], 3);
    Test.assertEqual(machine.getTotalWeightText(), "600kg");
    return true;
}

(:test)
function partialExerciseCountsOnlyCompletedSets(logger) {
    var session = new CaptureFitSession();
    var recorder = new TestRecorder(session);
    recorder.createTestFields();
    var machine = new WorkoutStateMachine([
        new Routine("Partial test", [new Exercise("Remo", 3, 12, 100, 1, 0)])
    ]);
    machine.useTestRecorder(recorder);
    machine.handleSelect();
    machine.handleSelect();
    machine.onExit();
    var rows = Storage.getValue("last_exercises");
    Test.assertEqual(rows.size(), 1);
    Test.assertEqual(rows[0][1], 1);
    Test.assertEqual(rows[0][4], 0);
    Test.assert(session.fields[7].data.find("1x12") != null);
    return true;
}

(:test)
function longExerciseNamePreservesNumbers(logger) {
    var result = new ExerciseSessionResult(new Exercise("Extension de triceps tras nuca con mancuerna", 3, 10, 225, 180, 25), 225);
    result.setsDone = 3;
    var summary = WorkoutRecorder.exerciseSummary(result);
    Test.assert(summary.length() <= 35);
    Test.assert(summary.find("...") != null);
    Test.assert(summary.find("3x10 22.5kg") != null);
    return true;
}

(:test)
function overflowExercisesAreReported(logger) {
    var session = new CaptureFitSession();
    var recorder = new TestRecorder(session);
    recorder.createTestFields();
    var rows = [];
    for (var i = 0; i < 8; i++) {
        var result = new ExerciseSessionResult(new Exercise("Test", 1, 10, 0, 1, 0), 0);
        result.setsDone = 1;
        rows.add(result);
    }
    recorder.updateExerciseDetails(rows);
    Test.assertEqual(session.fields[13].data, 2);
    Test.assertEqual(session.fields[12].data, "Test 1x10 0kg");
    recorder.discard();
    return true;
}

(:test)
function sixExercisesWithRealFitRecording(logger) {
    var exercises = [];
    for (var i = 0; i < 6; i++) {
        exercises.add(new Exercise("FIT exercise " + (i + 1), 1, 10, 100 + i * 10, 1, 0));
    }
    var machine = new WorkoutStateMachine([new Routine("GymApp six exercises", exercises)]);
    machine.handleSelect();
    Test.assertEqual(machine.getTestRecorder().getTestExerciseFieldCount(), 6);
    var events = 0;
    while (machine.getState() != 4 && events < 40) {
        machine.handleSelect();
        events++;
    }
    Test.assertEqual(machine.getSetsDone(), 6);
    Test.assertEqual(machine.getRecordingText(), "FIT guardado");
    var rows = Storage.getValue("last_exercises");
    Test.assertEqual(rows.size(), 6);
    logger.debug("Six exercise fields saved; FIT session budget: 238 bytes");
    return true;
}
