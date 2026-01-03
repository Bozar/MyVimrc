vim9script

import autoload 'temp_file.vim' as TF


export const DEFAULT: number = 0
export const LOC: number = 1
export const QUICK_FIX: number = 2

const MOVABLE_WINDOW_TYPE: list<string> = [
	'',
	'loclist',
	'preview',
	'quickfix',
]


export def IsValidWindowNumber(win_nr: number): bool
	return (win_nr >=# 1) && (win_nr <=# winnr('$'))
enddef


export def SplitWindow(layout: number, is_new_tab: bool): void
	if !IsMovableWindow()
		return
	endif

	const INVALID_LAYOUT: number = -1
	const LEFT_COLUMN_WIDTH_NARROW: number = 85
	const LEFT_COLUMN_WIDTH: number = 90
	const RIGHT_BOTTOM_HEIGHT: number = 10
	const OUTLINE_FILE: string = TF.GetTempFileName('outl')
	const LOC_FILE: string = TF.GetTempFileName('loc')

	if is_new_tab
		tab split
	endif

	wincmd o
	if layout ==# DEFAULT
		VerticalSplit(LEFT_COLUMN_WIDTH)
		TF.GotoTempBuffer(TF.NPAD)
		HorizontalSplit(RIGHT_BOTTOM_HEIGHT)
		TF.GotoTempBuffer(TF.BUFL)

	elseif layout ==# LOC
		VerticalSplit(LEFT_COLUMN_WIDTH_NARROW)
		TF.OpenTempFile(LOC_FILE)

	elseif layout ==# QUICK_FIX
		VerticalSplit(LEFT_COLUMN_WIDTH)
		TF.GotoTempBuffer(TF.NPAD)
		HorizontalSplit(RIGHT_BOTTOM_HEIGHT)
		TF.GotoTempBuffer(TF.BUFL)

	endif

	wincmd b
	if layout ==# QUICK_FIX
		belowright copen
	endif
enddef


export def GotoPreviousWindow(): void
	if !IsMovableWindow()
		return
	elseif winnr('$') ==# 1
		return
	endif

	const CURRENT_WINDOW: number = winnr()

	wincmd p
	if winnr() !=# CURRENT_WINDOW
		return
	endif
	GotoWindow()
enddef


export def GotoRightTopBottomWindow(is_right_top: bool): void
	if !IsMovableWindow()
		return
	endif

	var old_win_nr: number = winnr()
	var new_win_nr: number
	wincmd b
	if is_right_top
		new_win_nr = winnr('99k')
		execute ':' .. old_win_nr .. 'wincmd w'
		execute ':' .. new_win_nr .. 'wincmd w'
	endif
enddef


export def GotoWindow(prompt: string = 'Goto window? '): void
	const WIN_NUMBER: number = str2nr(input(prompt))

	if IsValidWindowNumber(WIN_NUMBER)
		execute ':' .. WIN_NUMBER .. 'wincmd w'
	endif
enddef


export def IsMovableWindow(): bool
	return index(MOVABLE_WINDOW_TYPE, win_gettype()) >=# 0
enddef


def VerticalSplit(width: number): void
	wincmd v
	:2wincmd w
	execute 'vertical resize ' .. width
	:1wincmd w
enddef


def HorizontalSplit(height: number): void
	wincmd s
	:2wincmd w
	execute 'resize ' .. height
enddef

