vim9script

import autoload 'save_load_state.vim' as SLS
import autoload 'data/snippet.vim' as DT_SN


# NOTE: ALWAYS USE NOREMAP OR NOREAB!
# Disable custom settings when something weird happens.
#
# iabbrev trigger_key <esc>:call <sid>MyFun()<cr>
# noremap! <unique> ( ()<left>
#
# Actually, `trigger_key` is expanded as `<esc>:call <sid>MyFun()<cr>)`. An
# extra right bracket is appended to the end because `(` is remapped to `()`.

export def LoadSnippet(file_type: string): void
	var join_line: string

	if has_key(DT_SN.ABBREVIATION, file_type)
		for i: string in keys(DT_SN.ABBREVIATION[file_type])
			execute 'inoreabbrev <silent> <buffer> ' .. i .. ' '
					.. DT_SN.ABBREVIATION[file_type][i]
		endfor
	endif
	if has_key(DT_SN.TEXT_BLOCK, file_type)
		for i: string in keys(DT_SN.TEXT_BLOCK[file_type])
			join_line = join(DT_SN.TEXT_BLOCK[file_type][i], '\r') 
			execute 'inoreabbrev <silent> <buffer> ' .. i
					.. ' <esc>:call <sid>InsertTextBlock("'
					.. join_line .. '")<cr>'
		endfor
	endif
enddef


def InsertTextBlock(text_block: string): void
	# Insert text block.
	const FIRST_LINE_NR: number = line('.')
	execute ':' .. FIRST_LINE_NR .. 's/\v$/' .. text_block .. '/'

	# Indent text block.
	const LAST_LINE_NR: number = line('.')
	const INDENT_RANGE: string = ':' .. FIRST_LINE_NR .. ',' .. LAST_LINE_NR
	const INDENT_SPACE: number = indent(FIRST_LINE_NR)
	execute INDENT_RANGE .. 'left ' .. INDENT_SPACE

	# Insert more spaces if required.
	const INSERT_SPACE: string = repeat(' ', &shiftwidth)
	execute INDENT_RANGE .. 's/' .. DT_SN.PATTERN_SPACE_PLACEHOLDER .. '/'
			.. INSERT_SPACE .. '/ge'

	# Move cursor.
	execute ':' .. FIRST_LINE_NR
	if search(DT_SN.PATTERN_INSERT_PLACEHOLDER, 'c', LAST_LINE_NR) ==# 0
		return
	endif
	SLS.SaveLoadState(v:true)
	execute ':s/' .. DT_SN.PATTERN_INSERT_PLACEHOLDER .. '//'
	execute ':' .. FIRST_LINE_NR
	if search(DT_SN.PATTERN_DEFAULT_PLACEHOLDER, 'c', LAST_LINE_NR) ># 0
		@/ = DT_SN.PATTERN_DEFAULT_PLACEHOLDER
	endif
	SLS.SaveLoadState(v:false)
	# Move cursor left because a snippet is usually triggered by <space>
	# key.
	normal! h
enddef

