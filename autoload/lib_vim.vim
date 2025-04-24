vim9script


export def IsValidWindowNumber(win_nr: number): bool
    return (win_nr >=# 1) && (win_nr <=# winnr('$'))
enddef


export def GetPlainSearchText(text: string): string
    return '\V\c' .. escape(text, '\/')
enddef

