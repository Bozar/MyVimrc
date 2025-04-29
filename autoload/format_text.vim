vim9script


import autoload 'save_load_state.vim' as SLS


const DEFAULT_LINE_SPACE: string = '2'
const DEFAULT_PLACEHOLDER: string = ' '

const FILE_TYPE_LOC: string = 'loc'


# 1. Trailing spaces will be REMOVED if 'placeholder' matches pattern '\v\s+'. 
#   Otherwise, 'file_type' decides how to handle them.
# 2. 'placeholder' is a string that will be added to the end of a line.
# 3. How to pass all arguments: FormatText 2 text \ \|
export def AutoFormat(
        line_space: string = DEFAULT_LINE_SPACE,
        file_type: string = &filetype,
        placeholder: string = DEFAULT_PLACEHOLDER
        ): void
    const NR_LINE_SPACE: number = str2nr(line_space)

    SLS.SaveLoadState(v:true)
    if placeholder =~# '\v\s+'
        RemoveTrailSpace()
    endif
    if file_type ==# FILE_TYPE_LOC
        FormatLoc()
    else
        FormatDefaultText(NR_LINE_SPACE, placeholder)
    endif
    SLS.SaveLoadState(v:false)
enddef


def RemoveTrailSpace(): void
    :%s/\v\s+$//ge
enddef


def RemoveExtraLine(line_space: number, placeholder: string): void
    const LAST_LINE: number = line('$')
    const PATTERN_BLANK_LINE: string = '\v^$'
    const PATTERN_MARKED_LINE: string = '\V' .. placeholder .. '\$'

    var line_count: number = 0

    if (line_space <# 0) || (1 + line_space ># LAST_LINE)
        return
    elseif search(PATTERN_MARKED_LINE, 'cwn') ># 0
        return
    endif

    for i: number in range(1, LAST_LINE)
        if getline(i) =~# PATTERN_BLANK_LINE
            line_count += 1
            if line_count ># line_space
                execute ':' .. i .. 's/$/' .. placeholder
            endif
        else
            line_count = 0
        endif
    endfor
    if search(PATTERN_MARKED_LINE, 'cwn') ># 0
        execute 'g/\V' .. placeholder .. '\$/d _'
    endif
enddef


def AddLastBlankLine(): void
    if getline(line('$')) =~# '\v^$'
        return
    endif
    :$s/\v$/\r
enddef


def FormatDefaultText(line_space: number, placeholder: string): void
    RemoveTrailSpace()
    RemoveExtraLine(line_space, placeholder)
    AddLastBlankLine()
enddef


def FormatLoc(): void
    setlocal fileencoding=utf-8
    setlocal fileformat=unix
    :%s/\r//ge
    # TODO: Implement JoinLine.
    #call <sid>LocalizationHelper('JoinLine')
enddef

