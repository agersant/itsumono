package itsumono.ui.cli;
import flash.display.Sprite;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.Vector;
import itsumono.internal.style.Swatch;
import itsumono.internal.TextUtils;
import msignal.Signal.Signal1;

/**
 * @author agersant
 */

class CLIAutoComplete extends Sprite {

	static inline var padding : Int = 5;
	static inline var triangleOffset : Int = 16;
	static inline var triangleHeight : Int = 8;
	static var resultTextFormat : TextFormat;
	static var confirmTextFormat : TextFormat;
	
	var background : Sprite;
	var textField : TextField;
	var lastResults : Array<AutoCompleteEntry>;
	var applyIndex : Int;
	
	public function new (refreshSignal : Signal1<String>) {
		
		super();
		applyIndex = 0;
		initTextFormats();
		refreshSignal.add(update);
		
		background = new Sprite();
		addChild(background);
		
		textField = new TextField();
		textField.y = padding;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.defaultTextFormat = CLIInput.textFormat;
		//textField.embedFonts = true;
		textField.autoSize = TextFieldAutoSize.LEFT;
		addChild(textField);
		
		background.addChild(textField);
		
	}
	
	function update (commandLine : String) : Void {
		
		lastResults = CLIAPI.runAutoComplete(commandLine);
		textField.text = "";
		applyIndex = 0;
		
		// Write text
		for (auto in lastResults) {
			if (textField.text.length > 0)
				textField.text += "\n";
			textField.text += auto.text;
		}

		// Apply formats (can't do both text and format in one loop since modifying the text wipes the formats)
		for (i in 0...lastResults.length) {
			var auto : AutoCompleteEntry = lastResults[i];
			var l : Int = textField.getLineOffset(i);
			for (search in auto.searchHighlights)
				textField.setTextFormat(resultTextFormat, l + search.start, l + search.end);
			for (ok in auto.confirmHighlights)
				textField.setTextFormat(confirmTextFormat, l + ok.start, l + ok.end);
		}
		
		// Draw background
		if (textField.text.length == 0) visible = false;
		else {
			visible = true;
			background.graphics.clear();
			background.graphics.beginFill(Swatch.CLIAutocompleteBGColor);
			background.graphics.drawRoundRect(0, 0, textField.width, textField.height + 2 * padding, 12, 12);
			var triangle : Vector<Float> = new Vector(6, true);
			triangle[0] = triangleOffset;
			triangle[1] = 0;
			triangle[2] = triangleOffset + triangleHeight*2;
			triangle[3] = 0;
			triangle[4] = triangleOffset + triangleHeight;
			triangle[5] = -triangleHeight;
			background.graphics.drawTriangles(triangle);
			background.graphics.endFill();
		}
		
	}
	
	public function getNextSuggestion() : String {
		if (lastResults == null || lastResults.length == 0)
			return null;
		var output : String = lastResults[applyIndex].text;
		var nextSpace : Int = output.indexOf(" ");
		var end : Int = nextSpace < 0 ? output.length : nextSpace;
		output = output.substring(0, end);
		applyIndex = (applyIndex + 1) % lastResults.length;
		return output;
	}
	
	static function initTextFormats() : Void {
		if (resultTextFormat == null) {
			resultTextFormat = TextUtils.cloneTextFormat(CLIInput.textFormat);
			resultTextFormat.color = Swatch.CLISearchResultFGColor;
		}
		if (confirmTextFormat == null) {
			confirmTextFormat = TextUtils.cloneTextFormat(CLIInput.textFormat);
			confirmTextFormat.color = Swatch.CLISearchConfirmFGColor;
		}
	}
	
}