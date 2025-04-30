vim9script


import autoload 'save_load_state.vim' as SLS
import autoload 'temp_file.vim' as TF
import autoload 'power_search.vim' as PS


export const MAP_NORMAL: number = 0
export const MAP_VISUAL: number = 1
export const MAP_SHIFT: number = 2

const DEBUG: bool = false
const EOL: string = "\n"

const LABEL_MARK: string = '#MARK#'
const LABEL_END: string = '#END#'
const LABEL_CR: string = '#CR#'

const PATTERN_MARK: string = '\v\C' .. LABEL_MARK
const PATTERN_END: string = '\v\C\t' .. LABEL_END .. '$'
const PATTERN_MARK_OR_END: string = '\v\C\t(' .. LABEL_MARK .. '|'
        .. LABEL_END .. ')'
const PATTERN_CR: string = '\v\C' .. LABEL_CR
# 1a2b3c-d4e5f6-...-7x8y9z
const PATTERN_GUID: string = '\v^((\a|\d)+-)+(\a|\d)+$'

# #MARK# -- SOURCE -- TARGET
const PATTERN_LONG_LINE: string = PATTERN_MARK .. '\t[^\t]+\t'
# ^ -- SOURCE -- TARGET
const PATTERN_SHORT_LINE: string = '\v\C^[^\t]+\t'
const PATTERN_BROKEN_LINE: string = '\v\t"[^\t]*$'

# #MARK# -- Source -- [NO TARGET] --
const PATTERN_NO_TARGET: string = PATTERN_MARK .. '\t[^\t]{-}\t\t'
const PATTERN_HEADER_GLOSSARY: string = 'Glossary {{{'
# -- [TARGET] --
const PATTERN_REPLACE_TARGET: string = '\v(\t)([^\t]{-})(\t)'

const GLOSSARY_TAG: list<string> = [
    'General',
    'NPC',
    'Location',
    'Item',
    'Skill \& Trait',
]

const INPUT_A: string = 'a'
const INPUT_B: string = 'b'
const INPUT_S: string = 's'
const INPUT_I: string = 'i'
const INPUT_C: string = 'c'


var snippet_source: string = ''
var snippet_target: string = ''


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
    # If g:PRIVATE_DATA exists, make sure it has the right data structure.
    if !exists('g:PRIVATE_DATA')
        echom 'ERROR: g:PRIVATE_DATA does not exist.'
        return
    endif

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
    const split_line: list<string> = split(getline(line('.')), '\t')
    # At least three parts: SOURCE -- TARGET -- [OPTIONAL] -- GUID
    if len(split_line) <# 3
        return
    endif
    # A line ends with '-0a1b3c...'.
    const GUID: string = split_line[-1]

    if GUID !~# PATTERN_GUID
        return
    endif
    @" = GUID
    SearchPattern(MAP_VISUAL, 1)
enddef


export def FilterSearchResult(map_mode: number): void
    const PATTERN: string = (map_mode ==# MAP_NORMAL) ? expand('<cword>') : @"

    TF.GoToTempWindow(TF.LOC)
    JoinLine()
    update

    if map_mode ==# MAP_SHIFT
        if search(PATTERN_NO_TARGET, 'cw') ># 0
            execute 'g/' .. PATTERN_NO_TARGET .. '/d _'
        endif
    else
        const ESCAPE_PATTERN: string = PS.EscapeVeryNoMagic(PATTERN)
        # ':h :v', ':h E538'
        if search(ESCAPE_PATTERN, 'cw') ># 0
            execute 'g/' .. ESCAPE_PATTERN .. '/d _'
            const IS_MATCH_ALL: bool = (search('.', 'cw') ==# 0)
            undo
            if !IS_MATCH_ALL
                execute 'g!/' .. ESCAPE_PATTERN .. '/d _'
            endif
        endif
    endif
    :1
enddef


export def CopySnippet(map_mode: number): void
    if map_mode ==# MAP_NORMAL
        CopySnippetNormal(split(getline('.'), '\t'))
    elseif map_mode ==# MAP_VISUAL
        CopySnippetVisual(@")
    endif
enddef


export def AddSnippet(): void
    if search(PATTERN_HEADER_GLOSSARY, 'bcnW') ># 0
        AddSnippetGlossary(getline('.'))
    elseif HasFullSnippet()
        AddSnippetTarget()
    endif
enddef


export def RemoveLabel(map_mode: number, is_remove_all: bool): void
    const COMMAND_RANGE: string = (map_mode ==# MAP_NORMAL) ? ':.' : ":'<, '>"

    SLS.SaveLoadState(v:true)
    if is_remove_all
        execute COMMAND_RANGE .. 's/' .. PATTERN_MARK_OR_END .. '//ge'
    endif
    execute COMMAND_RANGE .. 's/' .. PATTERN_CR .. '/\r/ge'
    SLS.SaveLoadState(v:false)
enddef


def AddSnippetGlossary(current_line: string): void
    const NORMAL_LENGTH: number = 3
    var split_line: list<string> = split(current_line, '\t')

    if (current_line ==# '') && HasFullSnippet()
        execute ':s/^/\r' .. snippet_source .. '\t' .. snippet_target .. '\t'
                .. GLOSSARY_TAG[0]
    elseif len(split_line) ==# NORMAL_LENGTH
        const CURRENT_TAG: string = split_line[NORMAL_LENGTH - 1]
        const CURRENT_INDEX: number = index(GLOSSARY_TAG, CURRENT_TAG)

        var new_tag: string

        if (CURRENT_INDEX ==# -1) || (CURRENT_INDEX + 1 >=# len(GLOSSARY_TAG))
            new_tag = GLOSSARY_TAG[0]
        else
            new_tag = GLOSSARY_TAG[CURRENT_INDEX + 1]
        endif
        split_line[NORMAL_LENGTH - 1] = new_tag
        execute ':s/\v^.*$/' .. (join(split_line, '\t'))
    endif
enddef


def AddSnippetTarget(): void
    const ESCAPE_SOURCE: string = PS.EscapeVeryNoMagic(snippet_source)
    const ESCAPE_TARGET: string = PS.EscapeSubstitution(snippet_target)

    unsilent const INPUT: string = input(''
            .. 'Source: [' .. ESCAPE_SOURCE .. ']' .. EOL
            .. 'Target: [' .. ESCAPE_TARGET .. ']' .. EOL
            .. '[I]nsert|[A]ppend text, [C]opy command' .. EOL
            .. '> '
            )

    SLS.SaveLoadState(v:true)
    const START_LINE: number = line('.')
    execute 'normal! ]z'
    const END_LINE: number = line('.')
    const COMMAND_INSERT: string = ':' .. START_LINE .. ',' .. END_LINE
            .. 'g/' .. ESCAPE_SOURCE .. '/' .. 's/' .. PATTERN_REPLACE_TARGET
            .. '/\1' .. ESCAPE_TARGET .. '\2\3/'
    const COMMAND_APPEND: string = ':' .. START_LINE .. ',' .. END_LINE
            .. 'g/' .. ESCAPE_SOURCE .. '/' .. 's/' .. PATTERN_REPLACE_TARGET
            .. '/\1\2' .. ESCAPE_TARGET .. '\3/'

    var save_command: string = ''

    execute ':' START_LINE
    if search(ESCAPE_SOURCE, 'cnW', END_LINE) ># 0
        if INPUT =~# INPUT_I
            execute COMMAND_INSERT
            save_command = COMMAND_INSERT
        elseif INPUT =~# INPUT_A
            execute COMMAND_APPEND
            save_command = COMMAND_APPEND
        endif
    endif
    SLS.SaveLoadState(v:false)
    if INPUT  =~# INPUT_C
        @" = save_command
    endif
enddef


export def JoinLine(): void
    if (search(PATTERN_END, 'cw') ==# 0)
            || (search(PATTERN_BROKEN_LINE, 'cw') ==# 0)
        return
    endif
    execute 'g/' .. PATTERN_BROKEN_LINE .. '/' .. ':.,/' .. PATTERN_END .. '/-1'
            .. 's/\v$/' .. LABEL_CR .. '/'
    execute ':%s/\v\C(' .. LABEL_CR .. ')+$/' .. LABEL_CR .. '/ge'
    execute 'g/' .. LABEL_CR .. '$/' .. ':.,/' .. PATTERN_END .. '/' .. 'join!'
enddef


def HasFullSnippet(): bool
    return (snippet_source !=# '') && (snippet_target !=# '')
enddef


def CopySnippetNormal(split_line: list<string>): void
    const MIN_LENGTH: number = 2
    const SHORT_LENGTH: number = 4
    const SPLIT_LENGTH: number = len(split_line)

    var mark_index: number = -1

    if SPLIT_LENGTH <# MIN_LENGTH
        return
    elseif SPLIT_LENGTH <# SHORT_LENGTH
        snippet_source = split_line[0]
        snippet_target = split_line[1]
    else
        for i: number in range(0, SPLIT_LENGTH)
            if (split_line[i] ==# LABEL_MARK) && (i + 2 <=# SPLIT_LENGTH)
                mark_index = i
                break
            endif
        endfor
        if mark_index >=# 0
            snippet_source = split_line[mark_index + 1]
            snippet_target = split_line[mark_index + 2]
        endif
    endif
enddef


def CopySnippetVisual(reg_text: string): void
    unsilent const INPUT: string = input(
            \ 'Source A: ' .. snippet_source .. EOL
            \ .. 'Target B: ' .. snippet_target .. EOL
            \ .. 'Register ": ' .. reg_text .. EOL
            \ .. 'Overwrite [A|B], [S]wap A & B' .. EOL
            \ .. '> '
            \ )

    if INPUT =~# INPUT_A
        snippet_source = reg_text
    endif
    if INPUT =~# INPUT_B
        snippet_target = reg_text
    endif
    if INPUT =~# INPUT_S
        const TEMP_SAVE: string = snippet_source
        snippet_source = snippet_target
        snippet_target = TEMP_SAVE
    endif
enddef

