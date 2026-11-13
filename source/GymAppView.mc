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

    private function centerText(dc, y, font, text) {
        dc.drawText(dc.getWidth() / 2, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawMenu(dc) {
        centerText(dc, 20, Graphics.FONT_SMALL, "Rutina " + _machine.getRoutinePositionText());
        centerText(dc, 52, Graphics.FONT_LARGE, _machine.getRoutineName());
        centerText(dc, 118, Graphics.FONT_XTINY, "UP/DOWN cambia dia");
        centerText(dc, 145, Graphics.FONT_SMALL, "START empezar");
        centerText(dc, 178, Graphics.FONT_XTINY, "BACK 4s salir");
    }

    private function drawActiveExercise(dc) {
        var exercise = _machine.getCurrentExercise();

        centerText(dc, 16, Graphics.FONT_SMALL, "Ejercicio");
        drawWrappedName(dc, exercise.name, 40);
        centerText(dc, 103, Graphics.FONT_MEDIUM, "Peso " + _machine.getCurrentWeightText());
        centerText(dc, 131, Graphics.FONT_LARGE, "Serie " + _machine.getCurrentSet() + "/" + exercise.sets);
        centerText(dc, 169, Graphics.FONT_SMALL, exercise.reps + " reps");
        centerText(dc, 190, Graphics.FONT_XTINY, "START hecha");
    }

    private function drawResting(dc) {
        var remaining = _machine.getRemainingRestSeconds();
        var total = _machine.getRestTotalSeconds();
        var label = formatSeconds(remaining);

        centerText(dc, 18, Graphics.FONT_SMALL, "Descanso");
        centerText(dc, 58, Graphics.FONT_LARGE, label);
        drawProgress(dc, remaining, total);
        centerText(dc, 152, Graphics.FONT_XTINY, "START saltar");
        centerText(dc, 174, Graphics.FONT_XTINY, "UP +15s   DOWN -15s");
    }

    private function drawEffort(dc) {
        centerText(dc, 20, Graphics.FONT_SMALL, "Esfuerzo");
        drawWrappedName(dc, _machine.getCurrentExercise().name, 47);
        centerText(dc, 111, Graphics.FONT_LARGE, _machine.getPendingEffort() + "/5");
        centerText(dc, 151, Graphics.FONT_XTINY, "1 facil  5 fallo");
        centerText(dc, 174, Graphics.FONT_XTINY, "UP/DOWN cambia");
        centerText(dc, 191, Graphics.FONT_XTINY, "START ok");
    }

    private function drawNextExercise(dc) {
        centerText(dc, 24, Graphics.FONT_XTINY, _machine.getProgressText());
        centerText(dc, 50, Graphics.FONT_MEDIUM, "Siguiente");
        drawWrappedName(dc, _machine.getCurrentExercise().name, 88);
        centerText(dc, 166, Graphics.FONT_SMALL, "Preparate");
    }

    private function drawFinished(dc) {
        centerText(dc, 20, Graphics.FONT_MEDIUM, "Completado");
        centerText(dc, 52, Graphics.FONT_SMALL, "Vol " + _machine.getTotalWeightText());
        centerText(dc, 82, Graphics.FONT_XTINY, "Series " + _machine.getSetsDone() + "  Reps " + _machine.getRepsDone());
        centerText(dc, 108, Graphics.FONT_XTINY, "Esf " + _machine.getAverageEffortText() + "  RepM " + _machine.getAverageRepsText());
        centerText(dc, 136, Graphics.FONT_XTINY, _machine.getRecordingText());
        centerText(dc, 166, Graphics.FONT_SMALL, "START/BACK");
        centerText(dc, 187, Graphics.FONT_SMALL, "menu");
    }

    // Dibujo simple para nombres largos. Evita cortar textos como "Press inclinado".
    // Si el nombre es corto, sale en una linea grande. Si es largo, se parte en dos.
    private function drawWrappedName(dc, name, y) {
        if (name.length() <= 15) {
            centerText(dc, y, Graphics.FONT_LARGE, name);
        } else {
            var splitAt = findSplitIndex(name);
            centerText(dc, y, Graphics.FONT_MEDIUM, name.substring(0, splitAt));
            centerText(dc, y + 28, Graphics.FONT_MEDIUM, name.substring(splitAt + 1, name.length()));
        }
    }

    private function findSplitIndex(name) {
        var mid = name.length() / 2;
        var best = 0;
        var bestDistance = 999;

        for (var i = 0; i < name.length(); i++) {
            if (name.substring(i, i + 1).equals(" ")) {
                var distance = i - mid;
                if (distance < 0) {
                    distance = 0 - distance;
                }
                if (distance < bestDistance) {
                    best = i;
                    bestDistance = distance;
                }
            }
        }

        if (best == 0) {
            return mid;
        }

        return best;
    }

    private function drawProgress(dc, remaining, total) {
        var width = 132;
        var height = 10;
        var x = (dc.getWidth() - width) / 2;
        var y = 124;
        var filled = 0;

        if (total > 0) {
            filled = (width * remaining) / total;
        }

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
