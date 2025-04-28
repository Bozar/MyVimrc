vim9script


import autoload 'save_load_state.vim' as SLS
import autoload 'layout.vim' as LT


const EOL: string = "\n"

const OVERWRITE_A: string = 'a'
const OVERWRITE_B: string = 'b'
const OVERWRITE_F: string = 'f'
const SWAP_AB: string = 's'
const ERASE_B: string = 'e'
const COPY_COMMAND: string = 'c'
const REPLACE_PATTERN: string = 'r'
const COLLECT_TEXT: string = 't'
const GREP_PATTERN: string = 'g'
const CFDO: string = 'd'


# Function variables cannot shadown script ones: ':h E1006'.
# https://www.reddit.com/r/vim/comments/1favdyy/
var substitute_text: string = ''
var search_pattern: string = ''
var grep_path: string = ''

var escaped_substitute_text: string = ''
var escaped_search_pattern: string = ''


# If the text starts with '\[vVmMcC]', it is used as is.
export def EscapeVeryNoMagic(text: string): string
    if text =~# '\v^\\[vVmMcC]'
        return text
    else
        return '\V\c' .. escape(text, '\/')
    endif
enddef


export def EscapeSubstitution(text: string): string
    return escape(text, '\/~&')
enddef


export def SearchHub(is_visual_mode: bool, is_lazy_search: bool = v:false): void
    const RAW_REGISTER: string = GetRawText(@")
    const ESCAPED_REGISTER: string = EscapeVeryNoMagic(RAW_REGISTER)
    const ORDERED_COMMANDS: list<string> = [
        REPLACE_PATTERN,
        COLLECT_TEXT,
        GREP_PATTERN,
        CFDO,
    ]

    ResetCursor(is_visual_mode, ESCAPED_REGISTER)
    SLS.SaveLoadState(v:true)
    # Set variables the first time for prompt message.
    escaped_search_pattern = EscapeVeryNoMagic(search_pattern)
    escaped_substitute_text = EscapeSubstitution(substitute_text)
    unsilent const INPUT: string = input(
            GetSearchResult(ESCAPED_REGISTER, is_lazy_search) .. EOL
            .. GetPrompt(
                    escaped_search_pattern, escaped_substitute_text, grep_path,
                    RAW_REGISTER
                    )
            )
    SLS.SaveLoadState(v:false)

    if trim(INPUT) ==# ''
        return
    endif
    # Note that search_pattern & substitute_text might be changed.
    SetVariable(INPUT, RAW_REGISTER)
    # Set variables the second time for command.
    escaped_search_pattern = EscapeVeryNoMagic(search_pattern)
    escaped_substitute_text = EscapeSubstitution(substitute_text)

    const IS_COPY: bool = (INPUT =~# COPY_COMMAND)
    const THIS_CMD: string = FilterCommand(INPUT, ORDERED_COMMANDS)

    # Save only one command.
    var command: string = ''

    if THIS_CMD ==# REPLACE_PATTERN
        command = GetCmdSubstitute(
                escaped_search_pattern, escaped_substitute_text
                )
    elseif THIS_CMD ==# COLLECT_TEXT
        command = GetCmdYank(escaped_search_pattern)
    elseif THIS_CMD ==# GREP_PATTERN
        command = GetCmdGrep(escaped_search_pattern, grep_path)
    elseif THIS_CMD ==# CFDO
        command = GetCmdCfdo(escaped_search_pattern, escaped_substitute_text)
    else
        command = ''
    endif

    # Copy or execute only one command.
    var save_yank: string

    if IS_COPY
        @" = command
    elseif escaped_search_pattern !=# EscapeVeryNoMagic('')
        SLS.SaveLoadState(v:true)
        if THIS_CMD ==# REPLACE_PATTERN
            unsilent execute ':' .. command
        elseif THIS_CMD ==# COLLECT_TEXT
            save_yank = ExeCmdYank(command)
        elseif THIS_CMD ==# GREP_PATTERN
            ExeCmdCfdo(command)
        elseif THIS_CMD ==# CFDO
            unsilent execute ':' .. command
        endif
        SLS.SaveLoadState(v:false)
        # @" is protected by 'SLS.SaveLoadState'. Its content remains unchanged.
        if THIS_CMD ==# COLLECT_TEXT
            @" = save_yank
        elseif THIS_CMD ==# GREP_PATTERN
            LT.SplitWindow(LT.QUICK_FIX, false)
        endif
    endif
enddef


def GetRawText(raw_register: string): string
    const FIRST_LINE_PATTERN: string = '\v([^\n]*)\n*.*'
    # If `register "` has more than one lines, keep only the first one.
    const RAW_TEXT: string = substitute(
            raw_register, FIRST_LINE_PATTERN, '\1', ''
            )
    return RAW_TEXT
enddef


def ResetCursor(is_visual_mode: bool, escaped_register: string): void
    if is_visual_mode
        normal! `<
        @/ = escaped_register
    endif
enddef


def GetSearchResult(escaped_register: string, is_lazy_search: bool): string
    const NO_RESULT: string = 'Match: 0, Line: 0'
    const UNKNOWN_RESULT: string = 'Match: ?, Line: ?'
    const NUMBER_PATTERN: string = '\v^\D*(\d+)\D*(\d+)\D*$'
    const MATCH_RESULT: string = 'Match: \1, Line: \2'

    if is_lazy_search
        return UNKNOWN_RESULT
    elseif escaped_register ==# EscapeVeryNoMagic('')
        return NO_RESULT
    endif

    const COMMAND_OUTPUT: string = execute(
            ':%s/' .. escaped_register .. '//gne'
            )

    if COMMAND_OUTPUT ==# ''
        return NO_RESULT
    else
        return substitute(COMMAND_OUTPUT, NUMBER_PATTERN, MATCH_RESULT, '')
    endif
enddef


def GetPrompt(
        pattern: string, text: string, path: string, raw_register: string
        ): string
    const INPUT: string = ''
            .. '--------------------------------------------' .. EOL
            .. '[A] Pattern: [' .. pattern .. ']' .. EOL
            .. '[B] Text: [' .. text .. ']' .. EOL
            .. '[F] File path: [' .. path .. ']' .. EOL
            .. '[@"]: [' .. raw_register .. ']' .. EOL
            .. '--------------------------------------------' .. EOL
            .. 'Overwrite [A|B|F], [S]wap A & B, [E]rase B,' .. EOL
            .. '[C]opy, [R]eplace, Collec[T], [G]rep, Cf[D]o' .. EOL
            .. '> '
    return INPUT
enddef


def SetVariable(input: string, raw_register: string): void
    # [register "] -> [search_pattern]
    if input =~# OVERWRITE_A
        search_pattern = raw_register
    # [register "] -> [substitute_text]
    endif
    if input =~# OVERWRITE_B
        substitute_text = raw_register
    endif
    # [register "] -> [grep_path]
    if input =~# OVERWRITE_F
        grep_path = raw_register
    endif

    # [substitute_text] <-> [search_pattern]
    if input =~# SWAP_AB
        const TEMP_SAVE: string = substitute_text
        substitute_text = search_pattern
        search_pattern = TEMP_SAVE
    endif

    # Clear [substitute_text]
    if input =~# ERASE_B
        substitute_text = ''
    endif
enddef


def GetCmdSubstitute(pattern: string, text: string): string
    const PATTERN_TEXT: string = pattern .. '/' .. text
    # Substitute whole text. Start from the current line.
    const COMMAND: string = '.,$s/' .. PATTERN_TEXT .. '/gce|'
            .. ':1,.s/' .. PATTERN_TEXT .. '/gce'
    return COMMAND
enddef


def GetCmdYank(pattern: string): string
    const COMMAND: string = 'vim9cmd @a = ""|g/' .. pattern .. '/yank A'
    return COMMAND
enddef


def ExeCmdYank(command: string): string
    const SAVE_REG: string = @a
    unsilent execute ':' .. command

    const SAVE_YANK: string = @a
    @a = SAVE_REG
    return SAVE_YANK
enddef


def GetCmdGrep(pattern: string, path: string): string
    const COMMAND: string = 'vim /' .. pattern .. '/j ' .. path
    return COMMAND
enddef


def GetCmdCfdo(pattern: string, text: string): string
    const PATTERN_TEXT: string = pattern .. '/' .. text
    const COMMAND: string = 'cfdo :%s/' .. PATTERN_TEXT .. '/gc'
    return COMMAND
enddef


def ExeCmdCfdo(command: string): void
    try
        silent execute ':' .. command
    catch /^Vim\%((\a\+)\)\=:E480:/ 
        unsilent echom 'E480: Pattern not found.'
    catch /^Vim\%((\a\+)\)\=:E683:/ 
        unsilent echom 'E684: Invalid file path.'
    endtry
enddef


def FilterCommand(input: string, ordered_commands: list<string>): string
    for i: string in ordered_commands
        if input =~# i
            return i
        endif
    endfor
    return ''
enddef

