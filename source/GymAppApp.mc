using Toybox.Application;
using Toybox.WatchUi;

// Clase principal de la app. Connect IQ crea esta clase al abrir la aplicacion.
class GymAppApp extends Application.AppBase {
    private var _machine;

    function initialize() {
        AppBase.initialize();
    }

    // Aqui creamos la vista y el delegado de botones.
    // La vista dibuja la pantalla; el delegado recibe Start, Back, Up y Down.
    function getInitialView() {
        _machine = new WorkoutStateMachine(RoutineFactory.createRoutines());
        var view = new GymAppView(_machine);
        var delegate = new GymAppInputDelegate(_machine);
        return [ view, delegate ];
    }

    function onStop(state) {
        if (_machine != null) {
            _machine.onExit();
        }
    }
}
