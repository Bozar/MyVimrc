vim9script

import autoload 'layout.vim' as LT
import autoload 'save_load_state.vim' as SLS


# NOTE: Add tag file paths to ~/.vimrc because they are private data. Refer to
# README.md for a sample vimrc.
export def GotoTag(tag: string): void
	const CURRENT_WINNR: number = winnr()

	SLS.SaveLoadState(v:true)
	LT.GotoWindow()
	if winnr() ==# CURRENT_WINNR
		SLS.SaveLoadState(v:false)
	endif

	unsilent execute 'tjump ' .. tag
	normal! 2kzt2j
	if winnr() !=# CURRENT_WINNR
		execute ':' .. CURRENT_WINNR .. 'wincmd w'
		SLS.SaveLoadState(v:false)
	endif
enddef
