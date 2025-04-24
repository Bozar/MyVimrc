vim9script


export def IsValidWindowNumber(win_nr: number): bool
    return (win_nr >=# 1) && (win_nr <=# winnr('$'))
enddef


export def IsInTempFolder(): bool
    return expand('%:h') ==# fnameescape(expand(GetTempDirectory()))
enddef


def GetTempDirectory(): string
    const TMP_WIN: string = $TEMP
    const TMP_LINUX: string = '/var/tmp'

    return (len(TMP_WIN) ># 0) ? TMP_WIN : TMP_LINUX
enddef


export def GetPlainSearchText(text: string): string
    return '\V\c' .. escape(text, '\/')
enddef

