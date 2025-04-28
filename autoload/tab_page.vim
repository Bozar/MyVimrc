vim9script


export def MoveTabPage(is_move_right: bool): void
    const CURRENT_TAB: number = tabpagenr()
    const LAST_TAB: number = tabpagenr('$')

    var next_tab: string = ''

    if is_move_right
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

