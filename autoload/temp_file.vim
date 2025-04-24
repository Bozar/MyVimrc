vim9script


export def IsInTempFolder(): bool
    return expand('%:h') ==# fnameescape(expand(GetTempDirectory()))
enddef


export def GetTempFile(file_type: string, has_path: bool = v:true): string
    const FILE_NAME: string = 'tmp.' .. file_type

    if has_path
        return expand(GetTempDirectory() .. '/' .. FILE_NAME)
    else
        return FILE_NAME
    endif
enddef


def GetTempDirectory(): string
    const TMP_WIN: string = $TEMP
    const TMP_LINUX: string = '/var/tmp'

    return (len(TMP_WIN) ># 0) ? TMP_WIN : TMP_LINUX
enddef

