vim9script

import autoload 'temp_file.vim' as TF


export const DEFAULT: number = 0
export const LOC: number = 1


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
        silent wincmd o
        # Left window
        wincmd v
        execute 'vertical resize ' .. LEFT_COLUMN_WIDTH
        # Right upper window, [Note Pad]
        :2wincmd w
        # TODO: Implement JumpToScratchBuffer() later.
        #call <sid>JumpToScratchBuffer('npad', 1)
        # Right lower window, [Outline]
        wincmd s
        :3wincmd w
        execute 'edit ' .. OUTLINE_FILE
        execute 'resize ' .. RIGHT_BOTTOM_HEIGHT
        # Back to window 1
        :1wincmd w

    elseif layout ==# LOC
        silent wincmd o
        wincmd v
        execute 'vertical resize ' .. LEFT_COLUMN_WIDTH_NARROW
        :2wincmd w
        execute 'edit ' .. LOC_FILE
        :1wincmd w

    else
        return
    endif
enddef

