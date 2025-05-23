vim9script


import autoload 'layout.vim' as LT


export const IS_GUI: bool = has('gui_running')
export const IS_WINDOWS: bool = has('win32') || has('win32unix')


export def SwitchIme(is_windows: bool, is_gui: bool, is_enter: bool): void
    if is_windows && is_gui
        if is_enter
            set noimdisable
            set iminsert=2
        else
            set imdisable
            set iminsert=0
        endif
    endif
enddef


# It causes more trouble than benefit to fork gVim. The function is reserved
# for reference.
export def ForkVim(is_gui: bool): void
    if is_gui
        !gvim
    endif
enddef


export def MaximizeWindow(is_win: bool, is_gui: bool): void
    if is_win
        simalt ~x
    elseif is_gui
        set guiheadroom=0
        winsize 123 31
    endif
enddef

