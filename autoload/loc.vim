vim9script


import autoload 'save_load_state.vim' as SLS
import autoload 'temp_file.vim' as TF
import autoload 'power_search.vim' as PS


export const MAP_NORMAL: number = 0
export const MAP_VISUAL: number = 1

const DEBUG: bool = false

const LABEL_MARK: string = '#MARK#'
const LABEL_END: string = '#END#'
const LABEL_CR: string = '#CR#'


export def ResetCursorPosition(): void
    const PATTERN_MARK: string = '\v\C' .. LABEL_MARK
    # #MARK# -- SOURCE -- TRANSLATION
    const PATTERN_LONG_LINE: string = PATTERN_MARK ..  '\t[^\t]+\t'
    # ^ -- SOURCE -- TRANSLATION
    const PATTERN_SHORT_LINE: string =  '\v\C^[^\t]+\t'
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


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


#export def (): void
#enddef


