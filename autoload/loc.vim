vim9script


import autoload 'save_load_state.vim' as SLS
import autoload 'temp_file.vim' as TF
import autoload 'power_search.vim' as PS


export const MAP_NORMAL: number = 0
export const MAP_VISUAL: number = 1
export const MAP_SHIFT: number = 2

const DEBUG: bool = false

const LABEL_MARK: string = '#MARK#'
const LABEL_END: string = '#END#'
const LABEL_CR: string = '#CR#'

const PATTERN_MARK: string = '\v\C' .. LABEL_MARK
const PATTERN_END: string = '\v\C\t' .. LABEL_END .. '$'
# #MARK# -- SOURCE -- TRANSLATION
const PATTERN_LONG_LINE: string = PATTERN_MARK .. '\t[^\t]+\t'
# ^ -- SOURCE -- TRANSLATION
const PATTERN_SHORT_LINE: string = '\v\C^[^\t]+\t'
const PATTERN_BROKEN_LINE: string = '\v\t"[^\t]*$'
# #MARK# -- Source -- [NO TRANSLATION] --
const PATTERN_NO_TRANSLATION: string = PATTERN_MARK .. '\t[^\t]{-}\t\t'


export def ResetCursorPosition(): void
    const LINE_TEXT: string = getline('.')
    const LINE_NR: number = line('.')

    if LINE_TEXT =~# PATTERN_LONG_LINE
        execute 'normal! ^'
        search(PATTERN_MARK, 'c', LINE_NR)
        execute 'normal! 2f	l'
    elseif LINE_TEXT =~# PATTERN_SHORT_LINE
        execute 'normal! ^f	l'
    endif
enddef


export def QuickCopy(): void
    var save_reg: string

    SLS.SaveLoadState(v:true)
    ResetCursorPosition()

    execute 'normal! yt	'
    # Reg " will be restored in the next step.
    save_reg = @"

    SLS.SaveLoadState(v:false)
    @" = save_reg
enddef


export def SearchPattern(map_mode: number, search_file_index: number): void
    const PATTERN: string = (map_mode ==# MAP_NORMAL) ? expand('<cword>') : @"
    const ESCAPE_PATTERN: string = shellescape(PATTERN, 1)

    const SEARCH_FILE: string = g:PRIVATE_DATA['LOC_FILE'][search_file_index]
    const OUTPUT_FILE: string = TF.GetTempFileName(TF.LOC)

    const COMMAND: string = 'grep -i ' .. ESCAPE_PATTERN .. ' ' .. SEARCH_FILE
            .. ' > ' .. OUTPUT_FILE

    system(COMMAND)
    TF.GoToTempWindow(TF.LOC)
    @" = DEBUG ? COMMAND : PATTERN
enddef


export def SearchGUID(): void
    const CURRENT_LINE: string = getline(line('.'))
    # A line ends with '-0a1b3c...'.
    const GUID: string = substitute(CURRENT_LINE, '\v^.*-((\a|\d)+)$', '\1', '')

    if GUID ==# CURRENT_LINE
        return
    endif
    @" = GUID
    SearchPattern(MAP_NORMAL, 1)
enddef


export def FilterSearchResult(map_mode: number): void
    const PATTERN: string = (map_mode ==# MAP_NORMAL) ? expand('<cword>') : @"

    TF.GoToTempWindow(TF.LOC)
    JoinLine()
    update

    if map_mode ==# MAP_SHIFT
        if search(PATTERN_NO_TRANSLATION, 'cw') ># 0
            execute 'g/' .. PATTERN_NO_TRANSLATION .. '/d _'
        endif
    else
        const ESCAPE_PATTERN: string = PS.EscapeVeryNoMagic(PATTERN)
        # ':h :v', ':h E538'
        execute 'g/' .. ESCAPE_PATTERN .. '/d _'
        const IS_MATCH_ALL: bool = (search('.', 'cw') ==# 0)
        undo
        if !IS_MATCH_ALL
            execute 'g!/' .. ESCAPE_PATTERN .. '/d _'
        endif
    endif
    :1
enddef


#export def (): void
#enddef


def JoinLine(): void
    if (search(PATTERN_END, 'cw') ==# 0)
            || (search(PATTERN_BROKEN_LINE, 'cw') ==# 0)
        return
    endif
    execute 'g/' .. PATTERN_BROKEN_LINE .. '/' .. '.,/' .. PATTERN_END .. '/-1'
            .. 's/\v$/' .. LABEL_CR .. '/'
    execute '%s/\v\C(' .. LABEL_CR .. ')+$/' .. LABEL_CR .. '/ge'
    execute 'g/' .. LABEL_CR .. '$/' .. '.,/' .. PATTERN_END .. '/' .. 'join!'
enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


