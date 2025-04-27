vim9script


import autoload 'save_load_view.vim' as SLV


const EOL: string = "\n"


# Function variables cannot shadown script ones: ':h E1006'.
# https://www.reddit.com/r/vim/comments/1favdyy/
var substitute_text: string = ''
var search_pattern: string = ''

var escaped_substitute_text: string = ''
var escaped_search_pattern: string = ''


export def EscapeVeryNoMagic(text: string): string
    return '\V\c' .. escape(text, '\/')
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
                    escaped_search_pattern, escaped_substitute_text, 
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
    if INPUT =~# 'e'
        command = GetCmdSubstitute(
                escaped_search_pattern, escaped_substitute_text
                )
    elseif INPUT =~# 'y'
        command = GetCmdYank(escaped_search_pattern)
    else
        command = ''
    endif

    # Copy or execute only one command.
    if INPUT =~# 'c'
        @" = command
    elseif escaped_search_pattern !=# EscapeVeryNoMagic('')
        if INPUT =~# 'e'
            ExeCmdSubstitute(command)
        elseif INPUT =~# 'y'
            ExeCmdYank(command)
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


def GetPrompt(pattern: string, text: string, raw_register: string): string
    const INPUT: string = 'Pattern A: [' .. pattern .. ']' .. EOL
            .. 'Text B: [' .. text .. ']' .. EOL
            .. 'Register ": [' .. raw_register .. ']' .. EOL
            .. 'Overwrite [A|B], [S]wap A & B, [D]elete B,' .. EOL
            .. '> [C]opy|[E]xecute command, [Y]ank all '
    return INPUT
enddef


def SetVariable(input: string, raw_register: string): void
    # [register "] -> [search_pattern]
    if input =~# 'a'
        search_pattern = raw_register
    # [register "] -> [substitute_text]
    endif
    if input =~# 'b'
        substitute_text = raw_register
    endif

    # [substitute_text] <-> [search_pattern]
    if input =~# 's'
        const TEMP_SAVE: string = substitute_text
        substitute_text = search_pattern
        search_pattern = TEMP_SAVE
    endif

    # Clear [substitute_text]
    if input =~# 'd'
        substitute_text = ''
    endif
enddef


def GetCmdSubstitute(pattern: string, text: string): string
    const COMMAND: string = '%s/' .. pattern .. '/' .. text .. '/gce'
    return COMMAND
enddef


def ExeCmdSubstitute(command: string): void
    ExecuteCommand(command)
enddef


def GetCmdYank(pattern: string): string
    const COMMAND: string = 'vim9cmd @a = ""|g/' .. pattern .. '/yank A'
    return COMMAND
enddef


def ExeCmdYank(command: string): void
    const SAVE_REG: string = @a
    ExecuteCommand(command)
    @" = @a
    @a = SAVE_REG
enddef


def ExecuteCommand(command: string): void
    SLV.SaveLoadView(v:true)
    unsilent execute ':' .. command
    SLV.SaveLoadView(v:false)
enddef

