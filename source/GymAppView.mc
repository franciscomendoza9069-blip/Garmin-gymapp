using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Timer;
using Toybox.WatchUi;

// Vista unica de la app. Dibuja una pantalla distinta segun el estado actual.
// Mantener una sola vista ahorra memoria y hace el flujo mas facil de seguir.
class GymAppView extends WatchUi.View {
    private var _machine;
    private var _timer;

    function initialize(machine) {
        View.initialize();
        _machine = machine;
        _timer = new Timer.Timer();
    }

    function onShow() {
        // Timer ligero: cada segundo actualiza la maquina de estados y redibuja.
        _timer.start(method(:onSecondTick), 1000, true);
    }

    function onHide() {
        _timer.stop();
    }

    function onSecondTick() {
        _machine.tick();
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        clear(dc);

        var state = _machine.getState();

        if (state == 0) {
            drawMenu(dc);
        } else if (state == 1) {
            drawActiveExercise(dc);
        } else if (state == 2) {
            drawResting(dc);
        } else if (state == 3) {
            drawNextExercise(dc);
        } else if (state == 5) {
            drawEffort(dc);
        } else {
            drawFinished(dc);
        }
    }

    private function clear(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    }

    private function drawMenu(dc) {
        ScreenText.line(dc, 18, 22, Graphics.FONT_SMALL, "Rutina " + _machine.getRoutinePositionText());
        ScreenText.name(dc, 46, 62, _machine.getRoutineName());
        ScreenText.line(dc, 116, 25, Graphics.FONT_TINY, "UP/DOWN: dia");
        ScreenText.line(dc, 143, 27, Graphics.FONT_SMALL, "START empezar");
        ScreenText.line(dc, 172, 22, Graphics.FONT_XTINY, "BACK 4s");
    }

    private function drawActiveExercise(dc) {
        var exercise = _machine.getCurrentExercise();

        ScreenText.line(dc, 18, 22, Graphics.FONT_SMALL, "Ejercicio");
        ScreenText.name(dc, 40, 69, exercise.name);
        ScreenText.line(dc, 110, 34, Graphics.FONT_LARGE, "Serie " + _machine.getCurrentSet() + "/" + exercise.sets);
        ScreenText.line(dc, 146, 25, Graphics.FONT_TINY, _machine.getCurrentWeightText() + " / " + exercise.reps + " reps");
        ScreenText.line(dc, 173, 22, Graphics.FONT_XTINY, "START");
    }

    private function drawResting(dc) {
        var remaining = _machine.getRemainingRestSeconds();
        var total = _machine.getRestTotalSeconds();
        var label = formatSeconds(remaining);

        ScreenText.line(dc, 18, 25, Graphics.FONT_SMALL, "Descanso");
        ScreenText.line(dc, 55, 54, Graphics.FONT_NUMBER_HOT, label);
        drawProgress(dc, remaining, total);
        ScreenText.line(dc, 135, 25, Graphics.FONT_TINY, "UP+15 DOWN-15");
        ScreenText.line(dc, 164, 27, Graphics.FONT_XTINY, "Saltar");
    }

    private function drawEffort(dc) {
        ScreenText.line(dc, 18, 22, Graphics.FONT_SMALL, "Esfuerzo");
        ScreenText.name(dc, 40, 69, _machine.getCurrentExercise().name);
        ScreenText.line(dc, 110, 34, Graphics.FONT_LARGE, _machine.getPendingEffort() + "/5");
        ScreenText.line(dc, 146, 25, Graphics.FONT_XTINY, "UP/DOWN: 1-5");
        ScreenText.line(dc, 173, 22, Graphics.FONT_XTINY, "START");
    }

    private function drawNextExercise(dc) {
        ScreenText.line(dc, 18, 25, Graphics.FONT_MEDIUM, "Siguiente");
        ScreenText.name(dc, 49, 69, _machine.getCurrentExercise().name);
        ScreenText.line(dc, 125, 27, Graphics.FONT_SMALL, _machine.getProgressText());
        ScreenText.line(dc, 164, 27, Graphics.FONT_SMALL, "Preparate");
    }

    private function drawFinished(dc) {
        ScreenText.line(dc, 18, 25, Graphics.FONT_MEDIUM, "Fin rutina");
        ScreenText.line(dc, 47, 34, Graphics.FONT_MEDIUM, "Vol " + _machine.getTotalWeightText());
        ScreenText.line(dc, 82, 25, Graphics.FONT_TINY, _machine.getSetsDone() + " series / " + _machine.getRepsDone() + " reps");
        ScreenText.line(dc, 108, 25, Graphics.FONT_XTINY, "Esf " + _machine.getAverageEffortText() + " / RepM " + _machine.getAverageRepsText());
        ScreenText.line(dc, 136, 27, Graphics.FONT_SMALL, _machine.getRecordingText());
        if (_machine.canRetrySave()) {
            ScreenText.line(dc, 166, 27, Graphics.FONT_XTINY, "Reintentar");
        } else {
            ScreenText.line(dc, 169, 22, Graphics.FONT_XTINY, "Menu");
        }
    }

    private function drawProgress(dc, remaining, total) {
        var width = 132;
        var height = 10;
        var x = (dc.getWidth() - width) / 2;
        var y = 121;
        var filled = 0;

        if (total > 0) {
            filled = (width * remaining) / total;
        }

        if (filled < 0) { filled = 0; }
        if (filled > width) { filled = width; }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, width, height);
        dc.fillRectangle(x, y, filled, height);
    }

    private function formatSeconds(seconds) {
        var minutes = seconds / 60;
        var secs = seconds % 60;

        if (secs < 10) {
            return minutes + ":0" + secs;
        }

        return minutes + ":" + secs;
    }
}
