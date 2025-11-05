vim9script


import autoload 'save_load_state.vim' as SLS


const LEADING_PATTERN: string = '\v^(\s*)'
const FILE_TO_COMMENT: dict<string> = {
	'vim': '#',
	'gdscript': '#',
	'sh': '#',
	'go': '\/\/',
}


export def AutoComment(file_type: string, is_normal: bool): void
	if ! has_key(FILE_TO_COMMENT, file_type)
		return
	endif

	var comment_string: string = FILE_TO_COMMENT[file_type]
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
	if HasComment(ln_0, ln_1, LEADING_PATTERN .. comment_string)
		#echom 'comment'
		DelComment(ln_0, ln_1, LEADING_PATTERN, comment_string)
	else
		#echom 'no comment'
		AddComment(ln_0, ln_1, LEADING_PATTERN, comment_string)
	endif
	SLS.SaveLoadState(v:false)
enddef


def HasComment(start: number, end: number, pattern: string): bool
	var current_line: number = start
	var search_line: number

	while current_line <=# end
		execute ':' .. current_line
		execute 'normal! 0'
		search_line = search(pattern, 'c', end)
		if search_line !=# current_line
			return v:false
		endif
		current_line += 1
	endwhile
	return v:true
enddef


def DelComment(
		start: number, end: number, leading_pattern: string,
		comment_string: string
): void
	execute ':' .. start .. ',' .. end .. 's/'
			.. leading_pattern .. comment_string
			.. '/\1' .. '/'
enddef


def AddComment(
		start: number, end: number, leading_pattern: string,
		comment_string: string
): void
	execute ':' .. start .. ',' .. end .. 's/'
			.. leading_pattern
			.. '/&' .. comment_string .. '/'
enddef

