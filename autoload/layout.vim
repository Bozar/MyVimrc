vim9script

import autoload 'temp_file.vim' as TF


export const DEFAULT: number = 0
export const WIN_LUD: number = 1
export const LOC: number = 2


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

    if layout ==# DEFAULT
        VerticalSplit(LEFT_COLUMN_WIDTH)
        TF.GoToTempBuffer(TF.NPAD)

    elseif layout ==# WIN_LUD
        VerticalSplit(LEFT_COLUMN_WIDTH)
        TF.GoToTempBuffer(TF.NPAD)
        HorizontalSplit(RIGHT_BOTTOM_HEIGHT)

    elseif layout ==# LOC
        VerticalSplit(LEFT_COLUMN_WIDTH_NARROW)
        execute 'edit ' .. LOC_FILE
    endif

    :1wincmd w
enddef


def VerticalSplit(width: number): void
    wincmd o
    wincmd v
    execute 'vertical resize ' .. width
    :2wincmd w
enddef


def HorizontalSplit(height: number): void
    wincmd s
    :3wincmd w
    execute 'resize ' .. height
enddef

