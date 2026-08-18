vim9script

import autoload 'state.vim' as ST

const PLACEHOLDER_TAB: string = '->'
const PATTERN_WORD: string = '\v^#* *(.{-})(\t|-\>).*$'

export def MoveCursor(): void
	ST.SaveState()
	execute 'normal! 0'
	if search('\t.', 'ce', line('.')) ># 0
		ST.DropState()
		return
	elseif search(PLACEHOLDER_TAB .. '.', 'ce', line('.')) ># 0
		ST.DropState()
		return
	endif
	ST.LoadState()
enddef

export def SwitchTab(is_normal: bool): void
	var ln_0: number
	var ln_1: number
	if is_normal
		ln_0 = line('.')
		ln_1 = line('.')
	else
		ln_0 = line("'<")
		ln_1 = line("'>")
	endif

	ST.SaveState()
	execute ':' .. ln_0
	execute 'normal! 0'
	if search('\t', 'c', ln_1) ># 0
		execute ':' .. ln_0 .. ',' .. ln_1 .. 's/'
			.. '\t/' .. PLACEHOLDER_TAB .. '/g'
	elseif search(PLACEHOLDER_TAB, 'c', ln_1) ># 0
		execute ':' .. ln_0 .. ',' .. ln_1 .. 's/'
			.. PLACEHOLDER_TAB .. '/\t' .. '/g'
	endif
	ST.LoadState()
enddef

export def CopyWord(): void
	@* = substitute(getline('.'), PATTERN_WORD, '\1', '')
enddef
