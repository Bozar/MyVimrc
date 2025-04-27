vim9script


import autoload 'save_load_view.vim' as SLV


const EOL: string = "\n"

const OVERWRITE_A: string = 'a'
const OVERWRITE_B: string = 'b'
const OVERWRITE_F: string = 'f'
const SWAP_AB: string = 's'
const DELETE_B: string = 'd'
const COPY_COMMAND: string = 'c'
const REPLACE_PATTERN: string = 'r'
const COLLECT_TEXT: string = 't'
const GREP_PATTERN: string = 'g'


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

    var command: string = ''

    ResetCursor(is_visual_mode, ESCAPED_REGISTER)
    SLV.SaveLoadView(v:true)
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
    SLV.SaveLoadView(v:false)

    if trim(INPUT) ==# ''
        return
    endif
    # Note that search_pattern & substitute_text might be changed.
    SetVariable(INPUT, RAW_REGISTER)
    # Set variables the second time for command.
    escaped_search_pattern = EscapeVeryNoMagic(search_pattern)
    escaped_substitute_text = EscapeSubstitution(substitute_text)

    # Save only one command.
    if INPUT =~# REPLACE_PATTERN
        command = GetCmdSubstitute(
                escaped_search_pattern, escaped_substitute_text
                )
    elseif INPUT =~# COLLECT_TEXT
        command = GetCmdYank(escaped_search_pattern)
    elseif INPUT =~# GREP_PATTERN
        command = GetCmdGrep(escaped_search_pattern, grep_path)
    else
        command = ''
    endif

    # Copy or execute only one command.
    if INPUT =~# COPY_COMMAND
        @" = command
    elseif escaped_search_pattern !=# EscapeVeryNoMagic('')
        SLV.SaveLoadView(v:true)
        if INPUT =~# REPLACE_PATTERN
            unsilent execute ':' .. command
        elseif INPUT =~# COLLECT_TEXT
            ExeCmdYank(command)
        elseif INPUT =~# GREP_PATTERN
            silent execute ':' .. command
        endif
        SLV.SaveLoadView(v:false)
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
            .. '-----------------------------------------------' .. EOL
            .. '[A] Pattern: [' .. pattern .. ']' .. EOL
            .. '[B] Text: [' .. text .. ']' .. EOL
            .. '[F] File path: [' .. path .. ']' .. EOL
            .. '[@"]: [' .. raw_register .. ']' .. EOL
            .. '-----------------------------------------------' .. EOL
            .. 'Overwrite [A|B|F], [S]wap A & B, [D]elete B,' .. EOL
            .. '> [C]opy command, [R]place, [G]rep, Collec[T]: '
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
    if input =~# DELETE_B
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


def ExeCmdYank(command: string): void
    const SAVE_REG: string = @a
    unsilent execute ':' .. command
    @" = @a
    @a = SAVE_REG
enddef


def GetCmdGrep(pattern: string, path: string): string
    const COMMAND: string = 'vim /' .. pattern .. '/j ' .. path 
    return COMMAND
enddef

