vim9script


const PATTERN_BRACKET: string = '\v\c\s+\{{3}\d*$'
const PATTERN_MARKDOWN: string = '\v\c^\#+\s+'


export def EditFoldMarker(file_type: string): void
	const FOLD_LEVEL: number = max([foldlevel('.'), 1])
	const LINE_TEXT: string = getline('.')

	if file_type ==# 'markdown'
		EditMarkerMarkdown(LINE_TEXT, FOLD_LEVEL)
	else
		EditMarkerBracket(LINE_TEXT, FOLD_LEVEL)
	endif
enddef


def EditMarkerBracket(line_text: string, fold_level: number): void
	if line_text =~# PATTERN_BRACKET
		execute ':s/' .. PATTERN_BRACKET .. '//'
	else
		execute ':s/$/ {{{' .. fold_level
	endif
enddef


def EditMarkerMarkdown(line_text: string, fold_level: number): void
	if line_text =~# PATTERN_MARKDOWN
		execute ':s/' .. PATTERN_MARKDOWN .. '//'
	else
		execute ':s/^/' .. repeat('#', fold_level) .. ' '
	endif
enddef

