vim9script

import autoload 'power_search.vim' as PS
import autoload 'layout.vim' as LT


export def SearchText(is_visual: bool, has_prompt: bool): void
    const EMPTY_LINE: string = '\v(^\s*$)|\n'
    const PROMPT: string = 'Search in window? '

    var current_line: string
    var goto_window: number
    var search_range: list<number>
    var search_text: string
    var current_window: number

    # vnoremap
    if is_visual
        current_line = @"
    else
        current_line = getline(line('.'))
    endif
    if current_line =~# EMPTY_LINE
        return
    endif

    # <leader><cr>
    if has_prompt
        unsilent goto_window = str2nr(input(PROMPT))
        if LT.IsValidWindowNumber(goto_window)
            search_range = range(goto_window, goto_window)
        else
            return
        endif
    else
        search_range = range(1, winnr('$'))
    endif

    search_text = PS.EscapeVeryNoMagic(trim(current_line))
    current_window = winnr()

    for i: number in search_range
        execute ':' .. i .. 'wincmd w'
        if (i !=# current_window) && (search(search_text, 'cw') > 0)
            @/ = search_text
            return
        endif
    endfor
    execute ':' .. current_window .. 'wincmd w'
enddef


export def ExecuteCurrentLine(is_normal_mode: bool): void
    const COMMAND: string = is_normal_mode ? getline('.') : @"
    const WIN_NUMBER: number = str2nr(input('Execute in window? '))

    if LT.IsValidWindowNumber(WIN_NUMBER)
        execute ':' .. WIN_NUMBER .. 'wincmd w'
    endif
    execute ':' .. COMMAND
enddef


