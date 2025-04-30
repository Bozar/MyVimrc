vim9script


import autoload 'layout.vim' as LT


export def MoveTabPage(is_move_down: bool): void
    if !LT.IsMovableWindow()
        if is_move_down
            normal! j
        else
            normal! k
        endif
        return
    endif

    const CURRENT_TAB: number = tabpagenr()
    const LAST_TAB: number = tabpagenr('$')

    var next_tab: string = ''

    if is_move_down
        if CURRENT_TAB <# LAST_TAB
            next_tab = '+1'
        else
            next_tab = '0'
        endif
    else
        if CURRENT_TAB ># 1
            next_tab = '-1'
        else
            next_tab = '$'
        endif
    endif
    execute 'tabmove ' .. next_tab
enddef


export def CloseTabPageToTheRight(): void
    while tabpagenr() <# tabpagenr('$')
        tabclose $
    endwhile
enddef


export def GotoTabPage(is_move_right: bool): void
    if !LT.IsMovableWindow()
        if is_move_right
            normal! l
        else
            normal! h
        endif
        return
    endif
    if is_move_right
        normal! gt
    else
        normal! gT
    endif
enddef

