vim9script

import autoload 'fold_marker.vim' as FM


const PATTERN_FUNC: string = '\v^(.{-})\s*([a-zA-Z0-9_]+\()(.*);$'
const PATTERN_TAIL: string = '\v;$'


export def ExpandLine(is_visual: bool): void
	if is_visual
		:'<,'>left 0
		:'<,'>s/\v\s*$//
		:'<,'>join
	endif
	if getline('.') !~# PATTERN_FUNC
		if is_visual
			normal! uu
		else
			FM.EditFoldMarker(&filetype)
		endif
		return
	endif

	execute ':s/' .. PATTERN_FUNC .. '/\1\r\2\3 {\r}'
	normal! k
enddef

