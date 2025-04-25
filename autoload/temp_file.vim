vim9script


# Temp file name
export const DEFAULT_NAME: string = 'tmp'

# Temp file type
export const LOC: string = 'loc'
export const NPAD: string = 'npad'
export const BUFL: string = 'bufl'


export def GoToTempWindow(
        file_extension: string, file_name: string = DEFAULT_NAME,
        is_new_win: bool = true
        ): void
    const FILE_NAME: string = GetTempFileName(file_extension, file_name)
    const WIN_NUMBER: number = GetTempWindowNumber(FILE_NAME)

    if WIN_NUMBER ># 0
        execute ':' .. WIN_NUMBER .. 'wincmd w'
    else
        if is_new_win
            split
        endif
        execute 'edit ' .. FILE_NAME
    endif
enddef


export def GoToTempBuffer(
        file_extension: string, file_name: string = DEFAULT_NAME
        ): void
    const FILE_NAME: string = GetTempFileName(file_extension, file_name)
    execute 'edit ' .. FILE_NAME
enddef


export def GetTempFileName(
        file_extension: string, file_name: string = DEFAULT_NAME,
        has_path: bool = v:true
        ): string
    const FILE_NAME: string = file_name .. '.' .. file_extension

    if has_path
        return expand(GetTempDirectory() .. '/' .. FILE_NAME)
    else
        return FILE_NAME
    endif
enddef


def GetTempWindowNumber(file_name: string): number
    const CURRENT_WIN: number = winnr()

    var win_number: number = 0

    for i: number in range(1, winnr('$'))
        execute ':' .. i .. 'wincmd w'
        if expand('%:p') ==# file_name
            win_number = winnr()
            break
        endif
    endfor

    execute ':' .. CURRENT_WIN .. 'wincmd w'
    return win_number
enddef


def GetTempDirectory(): string
    const TMP_WIN: string = $TEMP
    const TMP_LINUX: string = '/var/tmp'

    return (len(TMP_WIN) ># 0) ? TMP_WIN : TMP_LINUX
enddef

