vim9script

import autoload 'save_load_state.vim' as SLS
import autoload 'snippet/data.vim' as DT


# NOTE: ALWAYS USE NOREMAP OR NOREAB!
# Disable custom settings when something weird happens.
#
# iabbrev trigger_key <esc>:call <sid>MyFun()<cr>
# noremap! <unique> ( ()<left>
#
# Actually, `trigger_key` is expanded as `<esc>:call <sid>MyFun()<cr>)`. An
# extra right bracket is appended to the end because `(` is remapped to `()`.

export def LoadSnippet(file_type: string, file_extension: string): void
	var join_line: string
	var new_ft: string = get(DT.FIX_FILETYPE, file_extension, file_type)

	if has_key(DT.ABBREVIATION, new_ft)
		for i: string in keys(DT.ABBREVIATION[new_ft])
			execute 'inoreabbrev <silent> <buffer> ' .. i .. ' '
					.. DT.ABBREVIATION[new_ft][i]
		endfor
	endif
	if has_key(DT.TEXT_BLOCK, new_ft)
		for i: string in keys(DT.TEXT_BLOCK[new_ft])
			join_line = join(DT.TEXT_BLOCK[new_ft][i], '\r')
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
	#const INSERT_SPACE: string = repeat(' ', &shiftwidth)
	#execute INDENT_RANGE .. 's/' .. DT.PATTERN_INDENT_PLACEHOLDER .. '/'
	#		.. INSERT_SPACE .. '/ge'

	# Indent with <tab>.
	execute INDENT_RANGE .. 's/' .. DT.PATTERN_INDENT_PLACEHOLDER
		.. '/\t/ge'

	# Move cursor.
	execute ':' .. FIRST_LINE_NR
	if search(DT.PATTERN_INSERT_PLACEHOLDER, 'c', LAST_LINE_NR) ==# 0
		return
	endif
	SLS.SaveLoadState(v:true)
	execute ':s/' .. DT.PATTERN_INSERT_PLACEHOLDER .. '//'
	execute ':' .. FIRST_LINE_NR
	if search(DT.PATTERN_DEFAULT_PLACEHOLDER, 'c', LAST_LINE_NR) ># 0
		@/ = DT.PATTERN_DEFAULT_PLACEHOLDER
	endif
	SLS.SaveLoadState(v:false)
	# Move cursor left because a snippet is usually triggered by <space>
	# key.
	normal! h
enddef

