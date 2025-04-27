vim9script

import autoload 'temp_file.vim' as TF


export const DEFAULT: number = 0
export const LOC: number = 1
export const QUICK_FIX: number = 2


export def IsValidWindowNumber(win_nr: number): bool
    return (win_nr >=# 1) && (win_nr <=# winnr('$'))
enddef


export def SplitWindow(layout: number, is_new_tab: bool): void
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
        TF.GoToTempBuffer(TF.NPAD)
        HorizontalSplit(RIGHT_BOTTOM_HEIGHT)
        TF.GoToTempBuffer(TF.BUFL)

    elseif layout ==# LOC
        VerticalSplit(LEFT_COLUMN_WIDTH_NARROW)
        TF.OpenTempFile(LOC_FILE)

    elseif layout ==# QUICK_FIX
        VerticalSplit(LEFT_COLUMN_WIDTH)
        TF.GoToTempBuffer(TF.NPAD)
        HorizontalSplit(RIGHT_BOTTOM_HEIGHT)
        TF.GoToTempBuffer(TF.BUFL)

    endif

    :1wincmd w
    if layout ==# QUICK_FIX
        belowright copen
        :1wincmd w
    endif
enddef


export def GoToPreviousWindow(): void
    if winnr('$') ==# 1
        return
    endif

    const CURRENT_WINDOW: number = winnr()
    wincmd p
    if winnr() !=# CURRENT_WINDOW
        return
    endif

    const GOTO_WINDOW: number = str2nr(input('Goto window? '))
     if !IsValidWindowNumber(GOTO_WINDOW)
         return
     endif
    execute ':' .. GOTO_WINDOW .. 'wincmd w'
enddef


export def GoToLeftTopBottomWindow(is_left_top: bool): void
    var win_nr: number

    if is_left_top
        win_nr = 1
    else
        :1wincmd w
        win_nr = winnr('99j')
        wincmd p
    endif
    execute ':' .. win_nr .. 'wincmd w'
enddef


def VerticalSplit(width: number): void
    wincmd v
    execute 'vertical resize ' .. width
    :2wincmd w
enddef


def HorizontalSplit(height: number): void
    wincmd s
    :3wincmd w
    execute 'resize ' .. height
enddef

