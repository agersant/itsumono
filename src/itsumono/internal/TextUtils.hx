package itsumono.internal;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;

/**
 * @author agersant
 */

class TextUtils {
 
	public static function getLineHeight (textField : TextField) : Int {
		var sourceText = textField .text;
		textField.text = "oink";
		var metrics : TextLineMetrics = textField.getLineMetrics(0);
		textField.text = sourceText;
		return Math.ceil(metrics.height + metrics.descent); // Does not account for metrics.leading which is the spacing between lines
	}
	
	public static function cloneTextFormat (source : TextFormat) : TextFormat {
		var target = new TextFormat();
		target.rightMargin = source.rightMargin;
		target.leftMargin = source.leftMargin;
		target.color = source.color;
		target.font = source.font;
		target.size = source.size;
		return target;
	}
	
}