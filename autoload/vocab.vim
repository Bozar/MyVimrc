vim9script

import autoload 'save_load_state.vim' as SLS

const PLACEHOLDER_TAB: string = '->'

export def MoveCursor(): void
	var cursor: list<number> = getcurpos()
	execute 'normal! 0'
	if search('\t.', 'ce', line('.')) ># 0
		return
	elseif search(PLACEHOLDER_TAB .. '.', 'ce', line('.')) ># 0
		return
	endif
	setpos('.', cursor)
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

	SLS.SaveLoadState(v:true)
	execute ':' .. ln_0
	execute 'normal! 0'
	if search('\t', 'c', ln_1) ># 0
		execute ':' .. ln_0 .. ',' .. ln_1 .. 's/'
			.. '\t/' .. PLACEHOLDER_TAB .. '/g'
	elseif search(PLACEHOLDER_TAB, 'c', ln_1) ># 0
		execute ':' .. ln_0 .. ',' .. ln_1 .. 's/'
			.. PLACEHOLDER_TAB .. '/\t' .. '/g'
	endif
	SLS.SaveLoadState(v:false)
enddef
