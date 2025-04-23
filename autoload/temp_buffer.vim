vim9script


export def IsInTempFolder(): bool
    return expand('%:h') ==# fnameescape(expand(GetTempDirectory()))
enddef


def GetTempDirectory(): string
    const TMP_WIN: string = $TEMP
    const TMP_LINUX: string = '/var/tmp'

    return (len(TMP_WIN) ># 0) ? TMP_WIN : TMP_LINUX
enddef

