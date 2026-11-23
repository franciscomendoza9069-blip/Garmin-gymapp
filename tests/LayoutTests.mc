using Toybox.Graphics;
using Toybox.Test;

// El simulador proporciona las metricas reales de las fuentes del fr55.
// Este Dc comprueba el rectangulo de cada texto y detecta solapamientos.
(:test)
class LayoutAuditDc {
    var dc;
    var boxes;
    function initialize(realDc) { dc = realDc; boxes = []; }
    function getWidth() { return 208; }
    function getHeight() { return 208; }
    function getFontHeight(font) { return dc.getFontHeight(font); }
    function getTextWidthInPixels(text, font) { return dc.getTextWidthInPixels(text, font); }
    function setColor(a, b) { dc.setColor(a, b); }
    function clear() { dc.clear(); boxes = []; }
    function drawRectangle(x, y, w, h) { dc.drawRectangle(x, y, w, h); }
    function fillRectangle(x, y, w, h) { dc.fillRectangle(x, y, w, h); }
    function drawText(x, y, font, text, justification) {
        var w = getTextWidthInPixels(text, font);
        var h = getFontHeight(font);
        Test.assertMessage(text.find("...") == null, "Unexpected truncation: " + text);
        var left = x - w / 2;
        var right = x + (w + 1) / 2;
        var xs = [left, right];
        var ys = [y, y + h];
        for (var xi = 0; xi < 2; xi++) {
            var px = xs[xi];
            for (var yi = 0; yi < 2; yi++) {
                var py = ys[yi];
                Test.assertMessage((px - 104) * (px - 104) + (py - 104) * (py - 104) <= 99 * 99,
                    "Text outside safe circle: " + text);
            }
        }
        for (var bi = 0; bi < boxes.size(); bi++) {
            var box = boxes[bi];
            Test.assertMessage(y >= box[1] + box[3] || y + h <= box[1], "Overlapping rows: " + text);
        }
        boxes.add([left, y, w, h]);
        dc.drawText(x, y, font, text, justification);
    }
}

(:test)
class LayoutTestMachine {
    var state = 0;
    var retry = false;
    var exerciseName = "Press inclinado con mancuernas";
    function getState() { return state; }
    function getRoutinePositionText() { return "5/5"; }
    function getRoutineName() { return "Miercoles - Pierna"; }
    function getCurrentExercise() { return new Exercise(exerciseName, 12, 15, 1255, 180, 0); }
    function getCurrentWeightText() { return "125.5kg"; }
    function getCurrentSet() { return 12; }
    function getRemainingRestSeconds() { return 180; }
    function getRestTotalSeconds() { return 180; }
    function getPendingEffort() { return 5; }
    function getProgressText() { return "Mantener 125.5kg"; }
    function getTotalWeightText() { return "12345.5kg"; }
    function getSetsDone() { return 18; }
    function getRepsDone() { return 180; }
    function getAverageEffortText() { return "3.5"; }
    function getAverageRepsText() { return "10.0"; }
    function getRecordingText() { return retry ? "FIT no guardado" : "FIT guardado"; }
    function canRetrySave() { return retry; }
}

(:test)
function allScreensFitRoundDisplay(logger) {
    var bitmap = new Graphics.BufferedBitmap({:width => 208, :height => 208,
        :palette => [Graphics.COLOR_BLACK, Graphics.COLOR_WHITE]});
    var audit = new LayoutAuditDc(bitmap.getDc());
    var machine = new LayoutTestMachine();
    var fonts = ScreenText.fonts();
    for (var fi = 0; fi < fonts.size(); fi++) { logger.debug("Font " + fonts[fi] + " height " + audit.getFontHeight(fonts[fi])); }
    var names = ["Press inclinado con mancuernas", "Extension de triceps tras nuca con mancuerna",
            "Cruce de poleas desde abajo / Aperturas en polea", "Aductores en maquina (Aduccion de cadera)"];
    for (var ni = 0; ni < names.size(); ni++) {
        machine.exerciseName = names[ni];
        var view = new GymAppView(machine);
        for (var state = 0; state < 6; state++) {
            machine.state = state;
            view.onUpdate(audit);
            var minimums = [5, 5, 4, 4, 6, 5];
            Test.assertMessage(audit.boxes.size() >= minimums[state], "Missing labels on screen " + state);
        }
    }
    machine.state = 4;
    machine.retry = true;
    new GymAppView(machine).onUpdate(audit);
    return true;
}

(:test)
function wrappingKeepsEveryLetter(logger) {
    var bitmap = new Graphics.BufferedBitmap({:width => 208, :height => 208,
        :palette => [Graphics.COLOR_BLACK, Graphics.COLOR_WHITE]});
    var dc = bitmap.getDc();
    var text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var lines = ScreenText.wrap(dc, text, Graphics.FONT_SMALL, 80, 10);
    var restored = "";
    for (var i = 0; i < lines.size(); i++) { restored += lines[i]; }
    Test.assertEqual(restored, text);
    return true;
}

(:test)
function extremeNameStaysInsideItsBlock(logger) {
    var bitmap = new Graphics.BufferedBitmap({:width => 208, :height => 208,
        :palette => [Graphics.COLOR_BLACK, Graphics.COLOR_WHITE]});
    var dc = bitmap.getDc();
    var text = "";
    for (var i = 0; i < 100; i++) { text += "Nombre muy largo "; }
    var layout = ScreenText.nameLayout(dc, 40, 69, text);
    var lines = layout[1];
    Test.assert(lines.size() <= 3);
    Test.assert(lines.size() * (dc.getFontHeight(layout[0]) + 1) - 1 <= 69);
    for (var i = 0; i < lines.size(); i++) {
        Test.assert(dc.getTextWidthInPixels(lines[i], layout[0]) <= ScreenText.safeWidth(dc, 40, 69));
    }
    Test.assert(lines[lines.size() - 1].find("...") != null);
    return true;
}
