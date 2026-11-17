vim9script

#import autoload '' as

const SAVE_SESSION: string = 's'
const LOAD_SESSION: string = 'l'
const MERGE_SESSION: string = 'm'
const LIST_TOPIC: string = 't'
const EXPORT_HTML: string = 'h'

# NOTE: Placeholders actually appear in pairs in a snippet file:
# `===BEGIN_{PLACEHOLDER}` and `===END_{PLACEHOLDER}`.
final INPUT_TO_PLACEHOLDER: dict<string> = {}
INPUT_TO_PLACEHOLDER[SAVE_SESSION] = 'SAVE_SESSION'
INPUT_TO_PLACEHOLDER[LOAD_SESSION] = 'LOAD_SESSION'
INPUT_TO_PLACEHOLDER[MERGE_SESSION] = 'MERGE_SESSION'
INPUT_TO_PLACEHOLDER[LIST_TOPIC] = 'LIST_TOPIC'
INPUT_TO_PLACEHOLDER[EXPORT_HTML] = 'EXPORT_HTML'

const PROMPT: string =
	'[S]ave|[L]oad|[M]erge session, List [T]opic, Export [H]TML? '

const HEAD_BEGIN: string = '===BEGIN_'
const HEAD_END: string = '===END_'

export def CopySnippet(): void
	unsilent const INPUT: string = input(PROMPT)
	if ! has_key(INPUT_TO_PLACEHOLDER, INPUT)
		return
	endif

	const BODY: string = INPUT_TO_PLACEHOLDER[INPUT]
	const PAT_BEGIN: string = '/\V\C\^' .. HEAD_BEGIN .. BODY .. '\$/'
	const PAT_END: string = '/\V\C\^' .. HEAD_END .. BODY .. '\$/'
	silent execute ':' .. PAT_BEGIN .. '+1,' .. PAT_END .. '-1' .. 'y *'
enddef
