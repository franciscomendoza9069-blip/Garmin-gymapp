// Datos de UN ejercicio durante esta sesion, separados de la rutina prevista.
// El peso se captura al empezar y no cambia al calcular la proxima subida.
class ExerciseSessionResult {
    var name;
    var setsDone;
    var reps;
    var weightTenths;
    var effort;

    function initialize(exercise, sessionWeightTenths) {
        name = exercise.name;
        setsDone = 0;
        reps = exercise.reps;
        weightTenths = sessionWeightTenths;
        effort = 0; // Todavia no se ha respondido a la pregunta de esfuerzo.
    }

    // Storage admite datos simples, no instancias de nuestras clases.
    function toStoredArray() {
        return [name, setsDone, reps, weightTenths, effort];
    }
}
