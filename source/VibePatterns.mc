using Toybox.Attention;

// Patrones reutilizables. Asi se cambian una vez y se usan en toda la app.
class VibePatterns {
    static function restDone() {
        // Dos vibraciones cortas: fin de descanso.
        return [
            new Attention.VibeProfile(80, 250),
            new Attention.VibeProfile(0, 150),
            new Attention.VibeProfile(80, 250)
        ];
    }

    static function exerciseChange() {
        // Una vibracion larga: cambio de ejercicio.
        return [
            new Attention.VibeProfile(80, 800)
        ];
    }

    static function routineDone() {
        // Tres vibraciones cortas espaciadas: fin de rutina.
        return [
            new Attention.VibeProfile(80, 220),
            new Attention.VibeProfile(0, 180),
            new Attention.VibeProfile(80, 220),
            new Attention.VibeProfile(0, 180),
            new Attention.VibeProfile(80, 220)
        ];
    }
}
