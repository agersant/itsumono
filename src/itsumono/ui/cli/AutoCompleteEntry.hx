package itsumono.ui.cli;

/**
 * @author agersant
 */

typedef AutoCompleteEntry = {
	text : String,
	searchHighlights : Array<{start: Int, end: Int}>,
	confirmHighlights : Array<{start: Int, end: Int}>
}