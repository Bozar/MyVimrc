vim9script


import autoload 'layout.vim' as LT


export def ExecuteCurrentLine(): void
    const COMMAND: string = getline('.')
    const WIN_NUMBER: number = str2nr(input('Execute in window? '))

    if LT.IsValidWindowNumber(WIN_NUMBER)
        execute ':' .. WIN_NUMBER .. 'wincmd w'
    endif
    execute ':' .. COMMAND
enddef

