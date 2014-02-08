package itsumono.internal.style;
import flash.text.Font;

/**
 * @author agersant
 */

@:font("itsumono/internal/assets/fonts/FiraSans-Regular.ttf") class MainFont extends Font { }

class Fonts {
	
	public static function getMainFont() : String {
		Font.registerFont(MainFont);
		return (new MainFont()).fontName;
	}
	
}