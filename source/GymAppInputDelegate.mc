using Toybox.System;
using Toybox.Timer;
using Toybox.WatchUi;

// Centraliza los botones fisicos del Forerunner 55.
// No hay pantalla tactil, asi que todo el flujo se maneja aqui.
class GymAppInputDelegate extends WatchUi.InputDelegate {
    private var _machine;
    private var _backHeld;
    private var _backExitDone;
    private var _backTimer;

    function initialize(machine) {
        InputDelegate.initialize();
        _machine = machine;
        _backHeld = false;
        _backExitDone = false;
        _backTimer = new Timer.Timer();
    }

    // Captura cuando se pulsa un boton fisico.
    function onKeyPressed(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ESC) {
            startBackHoldTimer();
            return true;
        }

        return true;
    }

    // Captura cuando se suelta un boton fisico.
    function onKeyReleased(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ESC) {
            stopBackHoldTimer();

            // Si ya salimos por pulsacion larga, no hacemos nada mas.
            if (_backExitDone) {
                _backExitDone = false;
                return true;
            }

            // Si sueltas antes de 4 segundos, Back funciona normal.
            _machine.handleBack();
            WatchUi.requestUpdate();
            return true;
        }

        return true;
    }

    // Click normal de botones: se ejecuta al pulsar y soltar.
    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            _machine.handleSelect();
            WatchUi.requestUpdate();
            return true;
        }

        if (key == WatchUi.KEY_UP) {
            _machine.handleUp();
            WatchUi.requestUpdate();
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            _machine.handleDown();
            WatchUi.requestUpdate();
            return true;
        }

        return true;
    }

    private function startBackHoldTimer() {
        _backHeld = true;
        _backExitDone = false;
        _backTimer.stop();

        // Si Back sigue pulsado 4 segundos despues, cerramos la app.
        _backTimer.start(method(:exitIfBackStillHeld), 4000, false);
    }

    private function stopBackHoldTimer() {
        _backHeld = false;
        _backTimer.stop();
    }

    private function exitIfBackStillHeld() {
        if (_backHeld) {
            _backExitDone = true;
            System.exit();
        }
    }
}
