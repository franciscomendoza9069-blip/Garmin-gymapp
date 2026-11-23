using Toybox.Graphics;
using Toybox.Math;

// La pantalla es redonda: cerca de arriba y abajo hay menos ancho disponible.
// Medimos pixeles reales de la fuente, no el numero de letras de cada texto.
class ScreenText {
    static function safeWidth(dc, top, height) {
        var radius = (dc.getWidth() / 2) - 6;
        var center = dc.getHeight() / 2;
        var a = top - center;
        var b = top + height - center;
        if (a < 0) { a = 0 - a; }
        if (b < 0) { b = 0 - b; }
        var distance = (a > b) ? a : b;
        if (distance >= radius) { return 0; }
        return (2 * Math.sqrt(radius * radius - distance * distance)).toNumber();
    }

    static function fonts() {
        return [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL,
            Graphics.FONT_TINY, Graphics.FONT_XTINY];
    }

    // Una fila con altura reservada. Reducimos la fuente solo si hace falta.
    static function line(dc, top, height, preferred, text) {
        var choices = [preferred];
        choices.addAll(fonts());
        var limit = dc.getFontHeight(preferred);
        for (var i = 0; i < choices.size(); i++) {
            var font = choices[i];
            var fontHeight = dc.getFontHeight(font);
            if (fontHeight > height || fontHeight > limit) { continue; }
            var y = top + (height - fontHeight) / 2;
            var width = safeWidth(dc, y, fontHeight);
            if (dc.getTextWidthInPixels(text, font) <= width) {
                dc.drawText(dc.getWidth() / 2, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
                return;
            }
        }
        // Datos excepcionalmente largos: puntos suspensivos, nunca texto
        // dibujado por fuera del circulo. Los textos habituales caben completos.
        var small = Graphics.FONT_XTINY;
        var h = dc.getFontHeight(small);
        if (h > height) { return; }
        var y = top + (height - h) / 2;
        dc.drawText(dc.getWidth() / 2, y, small,
            shorten(dc, text, small, safeWidth(dc, y, h)), Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function name(dc, top, height, text) {
        var layout = nameLayout(dc, top, height, text);
        var font = layout[0];
        var lines = layout[1];
        var h = dc.getFontHeight(font);
        var y = top + (height - (lines.size() * (h + 1) - 1)) / 2;
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(dc.getWidth() / 2, y, font, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += h + 1;
        }
    }

    // Hasta tres lineas, centradas en su bloque y con la mayor fuente que cabe.
    static function nameLayout(dc, top, height, text) {
        var choices = fonts();
        var width = safeWidth(dc, top, height);
        for (var i = 0; i < choices.size(); i++) {
            var font = choices[i];
            var count = (height + 1) / (dc.getFontHeight(font) + 1);
            if (count > 3) { count = 3; }
            if (count < 1) { continue; }
            var lines = wrap(dc, text, font, width, count);
            if (lines != null) { return [font, lines]; }
        }
        var font = Graphics.FONT_XTINY;
        var count = (height + 1) / (dc.getFontHeight(font) + 1);
        if (count > 3) { count = 3; }
        // Solo se recurre a abreviar si el nombre supera incluso tres lineas.
        // Busqueda binaria: incluso un nombre desmesurado se resuelve en pocas
        // pasadas, sin crear arrays grandes ni bloquear el redibujado.
        var low = 0;
        var high = text.length();
        var best = ["..."];
        while (low <= high) {
            var middle = (low + high) / 2;
            var lines = wrap(dc, text.substring(0, middle) + "...", font, width, count);
            if (lines != null) {
                best = lines;
                low = middle + 1;
            } else {
                high = middle - 1;
            }
        }
        return [font, best];
    }

    static function wrap(dc, text, font, width, maxLines) {
        var remaining = TextTools.trim(text);
        var lines = [];
        while (remaining.length() > 0) {
            if (lines.size() >= maxLines) { return null; }
            if (dc.getTextWidthInPixels(remaining, font) <= width) {
                lines.add(remaining);
                return lines;
            }
            var end = 0;
            var space = 0;
            while (end < remaining.length()) {
                if (dc.getTextWidthInPixels(remaining.substring(0, end + 1), font) > width) { break; }
                if (remaining.substring(end, end + 1).equals(" ")) { space = end; }
                end++;
            }
            if (end == 0) { return null; }
            if (space > 0) { end = space; }
            lines.add(TextTools.trim(remaining.substring(0, end)));
            // No sumar 1: sin espacio de corte eso se comeria una letra.
            remaining = TextTools.trim(remaining.substring(end, remaining.length()));
        }
        if (lines.size() == 0) { lines.add(""); }
        return lines;
    }

    static function shorten(dc, text, font, width) {
        if (dc.getTextWidthInPixels(text, font) <= width) { return text; }
        var prefix = text;
        while (prefix.length() > 0 && dc.getTextWidthInPixels(prefix + "...", font) > width) {
            prefix = prefix.substring(0, prefix.length() - 1);
        }
        return prefix + "...";
    }
}
