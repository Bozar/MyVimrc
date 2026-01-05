vim9script

import autoload 'power_search.vim' as PS
import autoload 'layout.vim' as LT
import autoload 'fold_marker.vim' as FM


export def SearchText(is_visual: bool, has_prompt: bool): void
	const CURRENT_WIN: number = winnr()
	const EMPTY_LINE: string = '\v(^\s*$)|\n'
	var target_win: number = winnr('#')
	var current_line: string = getline(line('.'))
	# vnoremap
	if is_visual
		current_line = @"
	endif
	if current_line =~# EMPTY_LINE
		return
	endif

	const PROMPT: string = 'Search in window? '
	var goto_window: number = 0
	var search_range: list<number> = range(1, winnr('$'))
	# <leader><cr>
	if has_prompt
		unsilent goto_window = str2nr(input(PROMPT))
		if ! LT.IsValidWindowNumber(goto_window)
			return
		endif
		# Search a specific window.
		search_range = range(goto_window, goto_window)
	endif

	var search_text: string = PS.EscapeVeryNoMagic(trim(current_line))
	var has_target: bool = v:false
	for i: number in search_range
		execute ':' .. i .. 'wincmd w'
		if (i !=# CURRENT_WIN) && (search(search_text, 'cw') > 0)
			@/ = search_text
			target_win = i
			has_target = v:true
			break
		endif
	endfor
	# Reset current window & last window.
	if has_target
		execute ':' .. CURRENT_WIN .. 'wincmd w'
		execute ':' .. target_win .. 'wincmd w'
	# target_win remains unchanged: winnr('#').
	else
		execute ':' .. target_win .. 'wincmd w'
		execute ':' .. CURRENT_WIN .. 'wincmd w'
	endif
enddef


export def ExecuteLine(is_normal_mode: bool): void
	const COMMAND: string = is_normal_mode ? getline('.') : @"
	ExecuteCommand(COMMAND)
enddef


export def ArgaddLine(is_normal_mode: bool): void
	var ln_0: number
	var ln_1: number
	var lines: list<string>
	if is_normal_mode
		ln_0 = line('.')
		ln_1 = line('.')
	else
		ln_0 = line("'<")
		ln_1 = line("'>")
	endif
	for i: number in range(ln_0, ln_1)
		add(lines, getline(i))
	endfor

	var command: string = 'argadd ' .. join(lines, ' ')
	const YES: string = 'y'
	const EDIT: string = 'e'
	const ASK: string = '[' .. command .. ']: [y/e/N]? '
	const USR_INPUT: string = input(ASK)
	if USR_INPUT ==# YES
		execute ':%argdelete | ' .. command .. '| :%argdelete'
	elseif USR_INPUT ==# EDIT
		command = input('', command)
		execute ':' .. command
	else
		wall
	endif
enddef


export def CdLine(): void
	var new_dir: string = expand(getline('.'))
	if isdirectory(new_dir)
		echom 'Old: ' .. getcwd()
		execute ':cd ' .. new_dir
		echom 'New: ' .. getcwd()
	else
		FM.EditFoldMarker(&filetype)
	endif
enddef


export def GtdLine(): void
	const PAT_TODO: string = '\v\[[ ]\]\s+'
	const PAT_DONE: string = '\v\[[X]\]\s+'
	const STR_TODO: string = '[ ] '
	const STR_DONE: string = '[X] '
	const LINE: string = getline('.')
	if LINE =~# PAT_TODO
		execute ':s/' .. PAT_TODO .. '/' .. STR_DONE
	elseif LINE =~# PAT_DONE
		execute ':s/' .. PAT_DONE .. '/' .. STR_TODO
	else
		FM.EditFoldMarker(&filetype)
	endif
enddef


export def ExploreLine(): void
	var path: string = expand(getline('.'))

	if isdirectory(path)
		LT.GotoWindow('Explore in window? ')
	else
		path = ''
	endif
	execute 'Explore ' .. path
enddef


def ExecuteCommand(command: string): void
	LT.GotoWindow('Execute in window? ')
	execute ':' .. command
enddef

