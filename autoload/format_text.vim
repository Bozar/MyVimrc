vim9script


import autoload 'save_load_state.vim' as SLS
import autoload 'loc.vim' as LC


const DEFAULT_LINE_SPACE: string = '2'
const DEFAULT_PLACEHOLDER: string = ' '

const FILE_TYPE_LOC: string = 'loc'


# 1. 'placeholder' is a string that will be added to the end of a line. It is
#	one <space> by default. In this case, be sure to call RemoveTrailSpace()
#	before RemoveExtraLine().
# 2. How to pass an <space>: FormatText 2 text \ \|
export def AutoFormat(
		line_space: string = DEFAULT_LINE_SPACE,
		file_type: string = &filetype,
		placeholder: string = DEFAULT_PLACEHOLDER
): void
	const NR_LINE_SPACE: number = str2nr(line_space)

	SLS.SaveLoadState(v:true)
	if file_type ==# FILE_TYPE_LOC
		FormatLoc()
	else
		FormatDefaultText(NR_LINE_SPACE, placeholder)
	endif
	SLS.SaveLoadState(v:false)
enddef


def RemoveTrailSpace(): void
	:%s/\v\s+$//ge
enddef


def RemoveExtraLine(line_space: number, placeholder: string): void
	const LAST_LINE: number = line('$')
	const PATTERN_BLANK_LINE: string = '\v^$'
	const PATTERN_MARKED_LINE: string = '\V' .. placeholder .. '\$'

	var line_count: number = 0

	if (line_space <# 0) || (1 + line_space ># LAST_LINE)
		return
	elseif search(PATTERN_MARKED_LINE, 'cwn') ># 0
		return
	endif

	for i: number in range(1, LAST_LINE)
		if getline(i) =~# PATTERN_BLANK_LINE
			line_count += 1
			if line_count ># line_space
				execute ':' .. i .. 's/$/' .. placeholder
			endif
		else
			line_count = 0
		endif
	endfor
	if search(PATTERN_MARKED_LINE, 'cwn') ># 0
		execute 'g/\V' .. placeholder .. '\$/d _'
	endif
enddef


def AddLastBlankLine(): void
	if getline(line('$')) =~# '\v^$'
		return
	endif
	:$s/\v$/\r
enddef


def FormatDefaultText(line_space: number, placeholder: string): void
	RemoveTrailSpace()
	RemoveExtraLine(line_space, placeholder)
	AddLastBlankLine()
enddef


def FormatLoc(): void
	setlocal fileencoding=utf-8
	setlocal fileformat=unix
	:%s/\r//ge
	LC.JoinLine()
enddef

