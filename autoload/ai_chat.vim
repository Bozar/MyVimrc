vim9script

import autoload 'state.vim' as ST

# NOTE: A marker only contains: `0-9`, `A-Z`, `_`, and a keyword inside `[]`.
# For example, `THIS_IS_[M]ARKER_1`, `[THAT]_IS_MARKER_2`.
# Markers appear in pairs in an `ai_chat` file:
# `^===BEGIN_{MARKER}$` and `^===END_{MARKER}$`.

const HEAD_BEGIN: string = '===BEGIN_'
const HEAD_END: string = '===END_'
const MAX_MARKER_PER_LINE: number = 5

export def CopySnippet(): void
	const RAW_MARKER: string = GetMarker()
	if RAW_MARKER ==# ''
		return
	endif

	final INPUT_TO_MARKER: dict<string> = {}
	final PROMPT: list<string> = []
	ParseMarker(RAW_MARKER, INPUT_TO_MARKER, PROMPT)
	#unsilent echo INPUT_TO_MARKER
	#unsilent echo PROMPT
	unsilent const INPUT: string = input(join(PROMPT, "\n") .. "\n> ")
	if has_key(INPUT_TO_MARKER, INPUT)
		CopyLine(INPUT_TO_MARKER[INPUT])
	endif
enddef

export def AddLabel(): void
	const MARKER: string = toupper(getline('.'))
	execute ':s/^.*$/' .. HEAD_BEGIN .. MARKER .. '\r'
		.. HEAD_END .. MARKER .. '/'
enddef

# Google AI teaches me a clever trick to nest `[]` inside `[]`: `[][]`.
# REFER: `:h /\]`.
def GetMarker(): string
	ST.SaveState()
	const SAV_REG: string = @a
	@a = ''
	const PATTERN: string =
		'^' .. HEAD_BEGIN .. '[][:upper:][:digit:]_[]\+$'
	if search(PATTERN, 'cnw') ># 0
		execute 'g/' .. PATTERN .. '/y A'
	endif
	ST.LoadState()

	const OUTPUT: string = @a
	@a = SAV_REG
	return OUTPUT
enddef

def ParseMarker(
	raw_marker: string, out_marker: dict<string>, out_prompt: list<string>
): void
	const MKS: list<string> = uniq(sort(split(
		substitute(raw_marker, HEAD_BEGIN, '', 'g'), '\n'
	)))
	#unsilent echo MKS
	var marker_key: string = ''
	var prompt_line: list<string> = []
	for i: string in MKS
		marker_key = tolower(matchstr(i, '\v\[\zs.{-}\ze\]'))
		if (marker_key ==# '') || has_key(out_marker, marker_key)
			continue
		endif
		out_marker[marker_key] = i
		if len(prompt_line) >=# MAX_MARKER_PER_LINE
			add(out_prompt, join(prompt_line, ', '))
			prompt_line = []
		endif
		add(prompt_line, i)
	endfor
	# Add the last line.
	add(out_prompt, join(prompt_line, ', '))
enddef

def CopyLine(marker: string): void
	const PAT_BEGIN: string = '\V\C\^' .. HEAD_BEGIN .. marker .. '\$'
	const PAT_END: string = '\V\C\^' .. HEAD_END .. marker .. '\$'
	if search(PAT_BEGIN, 'cnw') ==# 0
		return
	endif
	if search(PAT_END, 'cnw') ==# 0
		silent execute ':/' .. PAT_BEGIN .. '/+1,$y *'
	else
		silent execute ':/' .. PAT_BEGIN .. '/+1,'
			.. '/' .. PAT_END .. '/-1' .. 'y *'
	endif
enddef
