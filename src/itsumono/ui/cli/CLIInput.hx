package itsumono.ui.cli;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import itsumono.internal.style.Fonts;
import itsumono.internal.style.Swatch;
import itsumono.internal.TextUtils;
import msignal.Signal.Signal1;
import openfl.Assets;

/**
 * @author agersant
 */

class CLIInput extends Sprite {
	
	public static var textFormat (default, null) : TextFormat;
	static inline var textOffsetY : Int = 2;

	var textField : TextField;
	var background : Sprite;
	var autoComplete : CLIAutoComplete;
	var updateSignal : Signal1<String>;
	
	public function new (w : Int) {
		
		super();
		updateSignal = new Signal1();
		initTextFormat();
		
		background = new Sprite();
		addChild(background);
		
		textField = new TextField();
		#if flash
			textField.tabEnabled = false;
		#end
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.defaultTextFormat = textFormat;
		textField.embedFonts = true;
		textField.type = TextFieldType.INPUT;
		textField.y = textOffsetY;
		textField.width = w;
		textField.height = TextUtils.getLineHeight(textField);
		textField.addEventListener(Event.CHANGE, function(e) { textChanged(); }, false, 0, false);
		
		background.addChild(textField);		
		background.graphics.beginFill(Swatch.CLIInputBGColor);
		background.graphics.drawRect(0, 0, w, textField.height + textOffsetY);
		background.graphics.endFill();
		
		autoComplete = new CLIAutoComplete(updateSignal);
		autoComplete.y = background.height + 10;
		addChild(autoComplete);
		
	}
	
	public function grabFocus() : Void {
		Lib.current.stage.focus = textField;
	}
	
	public function tabAutoComplete() : Void {
		#if flash
			if (textField.selectedText.length > 0) return;
		#end
		var suggestion = autoComplete.getNextSuggestion();
		if (suggestion != null) {
			textField.text = suggestion;
			textField.setSelection(textField.text.length, textField.text.length);
		}
	}
	
	public function getText() : String {
		return textField.text;
	}
	
	public function clear() : Void {
		textField.text = "";
		textChanged();
	}
	
	function textChanged() : Void {
		var accept = ~/`/g;
		textField.text = accept.replace(textField.text, "");
		updateSignal.dispatch(textField.text);
	}
	
	static function initTextFormat() : Void {
		if (textFormat == null) {
			textFormat = new TextFormat();
			textFormat.font = Fonts.getMainFont();
			textFormat.color = Swatch.CLIInputFGColor;
			textFormat.rightMargin = 5;
			textFormat.leftMargin = 5;
			textFormat.size = 14;
		}
	}
	
}
