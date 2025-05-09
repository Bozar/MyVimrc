vim9script


# https://shapeshed.com/vim-statuslines/
# https://jip.dev/posts/a-simpler-vim-statusline/

# show_mode:
# 0: show everything;
# 1: remove path;
# 2: remove path & file name;
# 3: show custom text.

# custom_text: Only available when show_mode ==# 3.
# 0: [Date]
# 1: [Notepad]
# 2: [Outline]
# 3: [Buffer List]
# 4: [Loc Output]

def g:MyStatusLine(show_mode: number, custom_text: number = 0): string
	var status_text: string = ''

	# File path
	const FILE_PATH: string = '%{expand("%:p:h:t:")}/'
	# File name
	const FILE_NAME: string = '%t'

	# 1. Core information
	# 1-1. Modified, readonly, help, preview
	status_text ..= '%m%r%h%w'
	# 1-2. Buffer number, window number
	status_text ..= ' [%{winnr()}]'
	#status_text ..= ' [%n-%{winnr()}]'
	const LEFT_PART: string = status_text

	# 2. Separation point
	const SEPARATION: string = '%='

	# 3. Current time
	# https://vi.stackexchange.com/questions/17875/
	#status_text = ''
	#CURRENT_TIME ..= '[%{strftime("%H:%M")}]'
	#CURRENT_TIME ..= '|%02.{strftime("%m")}'
	#CURRENT_TIME ..= '/%02{strftime("%d")}'
	#CURRENT_TIME ..= '/%{strftime("%Y")}]'
	#CURRENT_TIME ..= ' '
	#const CURRENT_TIME: string = status_text

	# 4. Cursor position
	status_text = ''
	# 4-1. Fileencoding, fileformat
	status_text ..= '[%{&fileencoding}|%{&fileformat}|'
	# 4-2. Cursor line number
	# Keep digits from right to left (just as text item).
	#status_text ..= '%1.5(%l%),'
	# 4-3. Total number of lines
	status_text ..= '%1.5L-'
	# 4-4. Percentage through file
	status_text ..= '%P]'
	const RIGHT_PART: string = status_text

	# [FILE_PATH | FILE_NAME], LEFT_PART, SEPARATION, [CURRENT_TIME],
	# RIGHT_PART

	# Show everything
	status_text = ''
	if show_mode ==# 0
		status_text ..= ' ' .. FILE_PATH .. FILE_NAME
	# Remove path
	elseif show_mode ==# 1
		status_text ..= FILE_NAME
	# Remove path & file name
	elseif show_mode ==# 2
		status_text ..= ''
	# Show custom text
	elseif show_mode ==# 3
		const CUSTOM_LIST: list<string> = [
			strftime('[%Y-%m-%d, %a]'),
			'[Notepad]',
			'[Outline]',
			'[Buffer List]',
			'[Loc Output]',
		]
		status_text ..= (custom_text ># len(CUSTOM_LIST) - 1)
				? CUSTOM_LIST[0]
				: CUSTOM_LIST[custom_text]
	endif

	status_text ..= LEFT_PART
	status_text ..= SEPARATION
	#if show_mode ==# 0
	#	status_text ..= CURRENT_TIME
	#endif
	status_text ..= RIGHT_PART
	return status_text
enddef


# https://vi.stackexchange.com/questions/21204/
def g:MyTabLine(): string
	var tab_text: string = ''
	const TAB_PREFIX = 'Tab #'

	for i: number in range(1, tabpagenr('$'))
		# Tab color
		tab_text ..= (i !=# tabpagenr())
				? '%#TabLine#'
				: '%#TabLineSel#'
		# Tab text
		tab_text ..= '%' .. i .. 'T ' .. TAB_PREFIX .. i .. ' '
	endfor
	# Space filler
	tab_text ..= '%#TabLineFill#%T%='
	return tab_text
enddef

