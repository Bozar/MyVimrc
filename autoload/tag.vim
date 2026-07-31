vim9script

import autoload 'layout.vim' as LT
import autoload 'state.vim' as ST

# NOTE: Add tag file paths to ~/.vimrc because they are private data. Refer to
# README.md for a sample vimrc.
export def GotoTag(tag: string): void
	const CURRENT_WINNR: number = winnr()

	ST.SaveState()
	LT.GotoWindow()
	if winnr() ==# CURRENT_WINNR
		ST.LoadState()
	endif

	unsilent execute 'tjump ' .. tag
	normal! 2kzt2j
	if winnr() !=# CURRENT_WINNR
		execute ':' .. CURRENT_WINNR .. 'wincmd w'
		ST.LoadState()
	endif
enddef
