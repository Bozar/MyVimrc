" Bozar's .vimrc file {{{1


" +========= Initialization =========+ {{{2
" +--------- ### ---------+ {{{3

set nocompatible

" 0: Default boot.
" 1: Custom boot. Set up a clean room for testing.
const s:INIT_FLAG = 0

const s:IS_GUI = has('gui_running')
const s:IS_WINDOWS = has('win32') || has('win32unix')

" https://github.com/lifepillar/vim-solarized8
const s:COLOR_SCHEME = 'solarized8'
if !s:IS_GUI
    set termguicolors
endif
" 0: Auto, 1: Always light, 2: Always dark
"const s:SWITCH_BACKGROUND = 0
"const s:TURN_ON_LIGHT = 6
"const s:TURN_OFF_LIGHT = 18

const s:COLOR_COLUMN = 81


" Keep `$MYVIMRC` to the minimum. Source another `.vimrc` (this file, for
" example) in a version control repository.
"
" Sample `g:PRIVATE_DATA`:
"
" let g:PRIVATE_DATA = {}
" let g:PRIVATE_DATA['PACK_PATH'] = ''
" let g:PRIVATE_DATA['WORKING_DIRECTORY'] = ''
" let g:PRIVATE_DATA['LOC_FILE'] = []
" let g:PRIVATE_DATA['OPEN_DESKTOP'] = []


" 0: Default boot.
if s:INIT_FLAG ==# 0
    " 1. Define constants based on `g:PRIVATE_DATA`.
    const s:PRIVATE_DATA = exists('g:PRIVATE_DATA') ? g:PRIVATE_DATA : {}

    const s:PACK_PATH = get(s:PRIVATE_DATA, 'PACK_PATH', [])
    const s:RUNTIME_PATH = get(s:PRIVATE_DATA, 'RUNTIME_PATH', [])
    const s:WORKING_DIRECTORY = get(s:PRIVATE_DATA, 'WORKING_DIRECTORY', '')
    const s:LOC_FILE = get(s:PRIVATE_DATA, 'LOC_FILE', [])

    unlet s:PRIVATE_DATA

    " 2. Change settings.
    for i in s:PACK_PATH
        execute 'set packpath+=' .. i
    endfor
    for i in s:RUNTIME_PATH
        execute 'set runtimepath+=' .. i
    endfor
    if s:WORKING_DIRECTORY !=# ''
        execute 'cd ' .. s:WORKING_DIRECTORY
    endif

    " 3. Load plugins: `pack/_/opt/[plugin]`. Put colorscheme plugin
    " (`vim-solarized8-1.5.1`) into the folder, but do not packadd it manually.
    packadd! matchit


" 1: Custom boot.
elseif s:INIT_FLAG ==# 1
    finish


else
    echom 'Incorrect INIT_FLAG: ' .. s:INIT_FLAG
    finish
endif


" +========= Vim Articles =========+ {{{2
" +--------- ### ---------+ {{{3

" Collect all articles: `let @a=''|g;http[^;];normal! "Ayy`.
"
" https://google.github.io/styleguide/vimscriptfull.xml
" https://arslan.io/2023/05/10/the-benefits-of-using-a-single-init-lua-vimrc-file/
" https://www.reddit.com/r/vim/wiki/vimrctips/
" https://irian.to/blogs/how-to-use-tags-in-vim-to-jump-to-definitions-quickly/


" +========= Settings =========+ {{{2
" +--------- ### ---------+ {{{3

" UI language: change the name of 'lang' folder will force Vim to use English.

filetype plugin indent on
syntax enable
set backspace=indent,eol,start
set autoread


" Do not insert 2 spaces after punctuations when joining lines.
set nojoinspaces
" Allow hiding modified buffers.
set hidden
" Do not beep.
set belloff=all
" Status line
set statusline=%!g:MyStatusLine(0)


" Display text in windows.
set number
set linebreak
" Do not break at `Tab`s.
set breakat=\ !@*-+;:,./?
set scrolloff=0
set display=lastline
set laststatus=2
set ambiwidth=double
set linespace=0
set list
" https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
set listchars=tab:].,
" BUG?: A long line containing tabs in a narrow window cannot be shown properly,
" if a tab is shown as three characters.
"set listchars=tab:].[,
"set listchars=tab:].[,lead:›
set cursorline


" Comnand line
set wildmode=full
set wildmenu
set cmdheight=2
set cmdwinheight=10
set history=998
set showcmd


" Indent
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set shiftround


" Search
set ignorecase
set incsearch
set smartcase


" Overwrite fold methods in filetype plugins.
set foldmethod=marker
" Unfold all text by default.
set foldlevel=99


" File formats
set fileformat=unix
set fileformats=unix,dos


" File encodings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1


" Case-insensitive file names
set fileignorecase


" Use both * and + registers when yanking in visual mode. Show the least GUI
" components.
set guioptions=aPc
"set guioptions=!aPc
" Do not blink cursor in all modes.
set guicursor+=a:blinkon0


" Tab page
set tabline=%!g:MyTabLine()
set showtabline=2


" Map leader
set notimeout
map <unique> <space> <nop>
let mapleader=' '


" Match pairs
set matchpairs+=<:>
set matchpairs+=《:》
set matchpairs+=“:”
set matchpairs+=‘:’
set matchpairs+=（:）


" Font
if s:IS_WINDOWS
    set renderoptions=type:directx
    set guifont=Consolas:h18:cANSI:qDRAFT
    "set guifont=Fira_Code_Medium:h16:W500:cANSI:qDRAFT
    set guifontwide=kaiti:h20:cGB2312:qDRAFT
else
    set guifont=DejaVu\ Sans\ \Mono\ 14
endif


" Colorscheme
" https://vi.stackexchange.com/questions/18932/
try
    execute 'colorscheme ' .. s:COLOR_SCHEME
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
endtry
set background=light


" +========= Key Mappings =========+ {{{2
" +--------- ### ---------+ {{{3

" +--------- Custom actions ---------+ {{{3

nnoremap <silent> <unique> <leader>fg :silent call <sid>FormatText()<cr>


" +========= Commands =========+ {{{2
" +--------- ### ---------+ {{{3

command -bar -nargs=? FormatText silent call <sid>FormatText(<f-args>)
command -bar -nargs=* InsertTimeStamp call <sid>InsertTimeStamp(<f-args>)


" +========= Plugins =========+ {{{2
" +--------- Netrw ---------+ {{{3

" Tree style listing
let g:netrw_liststyle = 3
" Hide banner
let g:netrw_banner = 0


" +--------- QuickFix ---------+ {{{3

let g:qf_disable_statusline = 1


" +--------- Filetype Plugins ---------+ {{{3

augroup load_filetype_plugin
    autocmd!
    autocmd FileType * call <sid>LoadFileTypePlugin(&filetype)
augroup END


" +========= Snippets =========+ {{{2
" +--------- ### ---------+ {{{3

let s:ABBREVIATION_DICT = {}

" Press <space> to trigger a snippet.
"
" `%I%`: Cursor position
" `%S%': White space
let s:SNIPPET_DICT = {}

let s:ABBREVIATION_DICT['vim'] = {
    \ '==': '==#',
    \ '!=': '!=#',
    \ '>>': '>#',
    \ '>=': '>=#',
    \ '<>': '<#',
    \ '<=': '<=#',
    \ '=~': '=~#',
    \ '!~': '!~#',
    \ 'iss': 'is#',
    \ 'issn': 'isnot#',
    \ 'cmda': 'autocmd',
    \ 'cmdd': 'command -bar -nargs=0',
    \ 'exee': 'execute',
\ }

let s:SNIPPET_DICT['vim'] = {
    \ 'funn': [
    \ 'function! s:%I%() abort',
    \ 'endfunction',
    \ ],
    \ 'fudd': [
    \ 'function! l:dict_func[''%I%'']() abort',
    \ 'endfunction',
    \ ],
    \ 'fuhh' :[
    \ 'function! s:%I%Helper(helper, ...) abort',
    \ '%S%let l:dict_func = {}',
    \ '%S%let l:dict_func[''OPT_ARG''] = a:000',
    \ '%S%let l:dict_func[''ARG_COUNT''] = a:0',
    \ '%S%lockvar! l:dict_func[''OPT_ARG'']',
    \ '%S%lockvar! l:dict_func[''ARG_COUNT'']',
    \ '',
    \ '',
    \ '%S%"function! l:dict_func['''']() abort',
    \ '%S%"endfunction',
    \ '',
    \ '',
    \ '%S%if has_key(l:dict_func, a:helper)',
    \ '%S%%S%call l:dict_func[a:helper]()',
    \ '%S%endif',
    \ 'endfunction',
    \ ],
    \ 'clls': [
    \ 'call <sid>%I%()',
    \ ],
    \ 'cllf': [
    \ 'call self[''%I%'']()',
    \ ],
    \ 'clld': [
    \ 'call l:dict_func[''%I%'']()',
    \ ],
    \ 'iff': [
    \ 'if %I%',
    \ 'elseif ',
    \ 'else ',
    \ 'endif',
    \ ],
    \ 'forr': [
    \ 'for l:i in %I%',
    \ 'endfor',
    \ ],
    \ 'whii': [
    \ 'while %I%',
    \ 'endwhile',
    \ ],
    \ 'letl': [
    \ 'let l:%I% = ',
    \ ],
    \ 'lets': [
    \ 'let s:%I% = ',
    \ ],
    \ 'letd': [
    \ '%I%let l:dict_func = {}',
    \ 'let l:dict_func[''OPT_ARG''] = a:000',
    \ 'let l:dict_func[''ARG_COUNT''] = a:0',
    \ 'lockvar! l:dict_func[''OPT_ARG'']',
    \ 'lockvar! l:dict_func[''ARG_COUNT'']',
    \ ],
    \ 'csts': [
    \ 'const s:%I% = ',
    \ ],
    \ 'cstl': [
    \ 'const l:%I% = ',
    \ ],
    \ 'augg': [
    \ 'augroup %I%',
    \ '%S%autocmd!',
    \ 'augroup END',
    \ ],
\ }

lockvar! s:SNIPPET_DICT
lockvar! s:ABBREVIATION_DICT


" +========= Library Functions =========+ {{{2
" +--------- ### ---------+ {{{3

function! s:IsValidWindowNumber(window) abort
    if (a:window <# 1) || (a:window ># winnr('$'))
        return 0
    endif
    return 1
endfunction


function! s:SetConstant(constant_name, value, do_not_overwrite = 0) abort
    const l:EXIST_CONSTANT = exists(a:constant_name)

    if a:do_not_overwrite
        if l:EXIST_CONSTANT
            return
        endif
    else
        if l:EXIST_CONSTANT
            execute 'unlet '    .. a:constant_name
        endif
    endif
    execute 'const ' .. a:constant_name .. ' = ' .. string(a:value)
endfunction


function! s:LoadFileTypePlugin(file_type) abort
    if exists('b:LoadFileTypePlugin_DONE')
        if b:LoadFileTypePlugin_DONE ==# a:file_type
            return
        endif
        unlet b:LoadFileTypePlugin_DONE
    endif
    const b:LoadFileTypePlugin_DONE = a:file_type

    call <sid>LoadAbbreviationDict(a:file_type)
    call <sid>LoadSnippetDict(a:file_type)

    call <sid>SetBufferKeyMap(a:file_type)
endfunction


function! s:SetBufferKeyMap(file_type) abort
    let l:dict_func = {}


    function! l:dict_func['loc']() abort
        nnoremap <buffer> <silent> <cr>
                \ :call <sid>LocalizationHelper('ResetCursorPosition')<cr>
        nnoremap <buffer> <silent> <c-cr>
                \ :call <sid>LocalizationHelper('QuickCopy')<cr>
        inoremap <buffer> <silent> <c-cr> #CR#

        nnoremap <buffer> <silent> <f1>
                \ :call <sid>LocalizationHelper('MapSearchKey', 0, 0)<cr>
        vnoremap <buffer> <silent> <f1>
                \ y:call <sid>LocalizationHelper('MapSearchKey', 1, 0)<cr>

        nnoremap <buffer> <silent> <f2>
                \ :call <sid>LocalizationHelper('MapSearchKey', 0, 1)<cr>
        vnoremap <buffer> <silent> <f2>
                \ y:call <sid>LocalizationHelper('MapSearchKey', 1, 1)<cr>
        nnoremap <buffer> <silent> <s-f2>
                \ :call <sid>LocalizationHelper('SearchGUID')<cr>

        nnoremap <buffer> <silent> <f3>
                \ :call <sid>LocalizationHelper('FilterSearchResult', 0)<cr>
        vnoremap <buffer> <silent> <f3>
                \ y:call <sid>LocalizationHelper('FilterSearchResult', 1)<cr>
        nnoremap <buffer> <silent> <s-f3>
                \ :call <sid>LocalizationHelper('FilterSearchResult', 2)<cr>

        nnoremap <buffer> <silent> <f4>
                \ :call <sid>LocalizationHelper('CopyGlossary', 0)<cr>
        vnoremap <buffer> <silent> <f4>
                \ y:call <sid>LocalizationHelper('CopyGlossary', 1)<cr>
        nnoremap <buffer> <silent> <s-f4>
                \ :call <sid>LocalizationHelper('CopyGlossary', -1)<cr>

        nnoremap <buffer> <silent> <f5>
                \ :call <sid>LocalizationHelper('InsertSnippetOrGlossary')<cr>

        nnoremap <buffer> <silent> <f6>
                \ :call <sid>LocalizationHelper('RemoveLabel', 0, 0)<cr>
        vnoremap <buffer> <silent> <f6>
                \ y:call <sid>LocalizationHelper('RemoveLabel', 1, 0)<cr>
        nnoremap <buffer> <silent> <s-f6>
                \ :call <sid>LocalizationHelper('RemoveLabel', 0, 1)<cr>
        vnoremap <buffer> <silent> <s-f6>
                \ y:call <sid>LocalizationHelper('RemoveLabel', 1, 1)<cr>

        nnoremap <buffer> <silent> <f7>
                \ :call <sid>LocalizationHelper('MapSearchKey', 0, 2)<cr>
        vnoremap <buffer> <silent> <f7>
                \ y:call <sid>LocalizationHelper('MapSearchKey', 1, 2)<cr>

    endfunction


    if has_key(l:dict_func, a:file_type)
        call l:dict_func[a:file_type]()
    endif
endfunction


" https://vim.fandom.com/wiki/Insert_current_date_or_time
function! s:InsertTimeStamp(show_mode = 0, always_insert = 0,
        \ keyword = 'Last Update: ') abort
    let l:dict_func = {}


    function! l:dict_func['_InsertTimeStamp'](always_insert, keyword) abort
        const l:PATTERN = '\v\C(\V' .. a:keyword .. '\v).*'
        const l:MAX_LINE = 5
        const l:LAST_LINE = line('$')

        if l:MAX_LINE ># l:LAST_LINE
            unlet l:MAX_LINE
            const l:MAX_LINE = l:LAST_LINE
        endif

        const l:CURSOR_LINE = line('.')
        execute 1
        const l:SEARCH_RESULT = search(l:PATTERN, 'c')
        const l:SEARCH_LINE = line('.')

        const l:TIME = <sid>GetTimeStamp(0)
        if l:SEARCH_RESULT && (
                \ (l:SEARCH_LINE <=# l:MAX_LINE) ||
                \ (l:SEARCH_LINE >=# l:LAST_LINE - l:MAX_LINE)
                \ )
            execute l:SEARCH_LINE .. 's/' .. l:PATTERN .. '/\1' .. l:TIME .. '/'
        elseif a:always_insert
            execute l:CURSOR_LINE .. 's/\v$/\r' .. a:keyword .. l:TIME .. '/'
        endif
    endfunction


    function! l:dict_func['_InsertDate']() abort
        const l:TIME = <sid>GetTimeStamp(1)
        execute 's/\v$/\r' .. l:TIME .. '/'
    endfunction


    function! l:dict_func['_ShowTime']() abort
        echo <sid>GetTimeStamp(2)
    endfunction


    call <sid>SaveRestoreView(0)
    if a:show_mode ==# 0
        const l:TIME = l:dict_func['_InsertTimeStamp'](a:always_insert,
                \ a:keyword)
    elseif a:show_mode ==# 1
        const l:TIME = l:dict_func['_InsertDate']()
    else
        const l:TIME = l:dict_func['_ShowTime']()
    endif
    call <sid>SaveRestoreView(1)
endfunction


function! s:GetTimeStamp(show_mode) abort
    if a:show_mode ==# 0
        return strftime('%Y-%m-%d, %H:%M:%S')
    elseif a:show_mode ==# 1
        return strftime('[%Y-%m-%d, %a]')
    elseif a:show_mode ==# 2
        return strftime('%Y-%m-%d, %a, %H:%M')
    endif
    return strftime('%Y-%m-%d, %H:%M:%S')
endfunction


function! s:LoadSnippetDict(file_type) abort
    if !has_key(s:SNIPPET_DICT, a:file_type)
        return
    endif

    for l:i in keys(s:SNIPPET_DICT[a:file_type])
        " Return to normal mode. Insert text.
        execute 'iabbrev <silent> <buffer> ' .. l:i
                \ .. ' <esc>:call <sid>InsertSnippet("' .. l:i .. '")<cr>'
    endfor
endfunction


function! s:LoadAbbreviationDict(file_type) abort
    if !has_key(s:ABBREVIATION_DICT, a:file_type)
        return
    endif

    const l:ABBREVIATION = s:ABBREVIATION_DICT[a:file_type]
    for l:i in keys(l:ABBREVIATION)
        execute 'iabbrev <silent> <buffer> ' .. l:i .. ' '
                \ .. l:ABBREVIATION[l:i]
    endfor
endfunction


function! s:InsertSnippet(trigger) abort
    const l:INSERT_PLACEHOLDER = '%I%'
    const l:SPACE_PLACEHOLDER = '%S%'

    " Get snippet.
    if !has_key(s:SNIPPET_DICT, &filetype)
        return
    else
        let l:snippet = s:SNIPPET_DICT[&filetype]
        if !has_key(l:snippet, a:trigger)
            return
        endif
    endif

    " Insert snippet.
    let l:first_line = line('.')
    execute 's/\v$/' .. join(l:snippet[a:trigger], "\r") .. '/'

    " Indent snippet.
    let l:last_line = line('.')
    let l:range = l:first_line .. ',' .. l:last_line
    let l:indent = indent(l:first_line)
    execute l:range .. 'left ' .. l:indent

    let l:search = '\V\C' .. l:SPACE_PLACEHOLDER
    let l:space = repeat(' ', &shiftwidth)
    execute l:range .. 's/' .. l:search .. '/' .. l:space .. '/ge'

    " Move cursor.
    execute l:first_line
    let l:search = '\V\C' .. l:INSERT_PLACEHOLDER
    let l:cursor = searchpos(l:search, 'c', l:last_line)
    let l:cursor = searchpos(l:search, 'cn', l:last_line)

    " Do not move cursor if `searchpos()` returns [0, 0]. This applies to
    " incorrect snippets.
    if l:cursor[0] <# l:first_line
        return
    endif

    let l:range = l:cursor[0]
    execute l:range .. 's/' .. l:search .. '//'
    call cursor(l:cursor)
    " Move cursor left because a snippet is usually triggered by <space> key.
    normal! h
endfunction


" 0: save, 1: restore
function! s:SaveRestoreView(restore)
    let l:dict_func = {}


    function! l:dict_func['_SetCount'](add_count) abort
        const l:TEMP_COUNT = b:SaveRestoreView_COUNT + a:add_count
        unlet b:SaveRestoreView_COUNT
        const b:SaveRestoreView_COUNT = l:TEMP_COUNT
    endfunction


    function! l:dict_func['_SaveView']() abort
        if b:SaveRestoreView_COUNT ==# 0
            const b:SaveRestoreView_SAVED = {
                \ 'FOLD': &foldenable,
                \ 'WIN': winsaveview(),
            \ }
            setlocal nofoldenable
        endif
        call self['_SetCount'](1)
    endfunction


    function! l:dict_func['_RestoreView']() abort
        if b:SaveRestoreView_COUNT ># 0
            call self['_SetCount'](-1)
        endif
        if b:SaveRestoreView_COUNT ==# 0
            let &foldenable = b:SaveRestoreView_SAVED['FOLD']
            call winrestview(b:SaveRestoreView_SAVED['WIN'])
            unlet b:SaveRestoreView_SAVED
            unlet b:SaveRestoreView_COUNT
        endif
    endfunction


    if !exists('b:SaveRestoreView_COUNT')
        const b:SaveRestoreView_COUNT = 0
    endif
    if a:restore ==# 0
        call l:dict_func['_SaveView']()
    else
        call l:dict_func['_RestoreView']()
    endif
endfunction


function! s:FormatText(line_space = 2) abort
    let l:dict_func = {}


    function! l:dict_func['_DeleteTrailSpace']() abort
        const l:SPACE = '\v\s+$'
        if search(l:SPACE, 'cnw')
            execute '%s/' .. l:SPACE .. '//g'
        endif
    endfunction


    function! l:dict_func['_DeleteBlankLine'](line_space = 0) abort
        " If the placeholder is a non-blank string, use these search patterns.
        " You may also need to check if the placeholder already exists in a
        " file.

        "const l:BLANK_PATTERN = '\v^\s*$'
        "const l:TEXT_PATTERN = '\v\S+\s*$'
        "const l:PLACEHOLDER = '####'
        const l:BLANK_PATTERN = '\v^$'
        const l:TEXT_PATTERN = '\v\S+$'
        const l:PLACEHOLDER = ' '

        const l:DELETE_TRAIL = '\V' .. l:PLACEHOLDER .. '\+\v$'
        const l:LAST_LINE = line('$')

        " Comment this line if the placeholder is a non-blank string and you
        " want to keep existing trailing spaces as is.
        call self['_DeleteTrailSpace']()

        if !search(l:BLANK_PATTERN, 'cwn')
            return
        elseif a:line_space ==# 0
            execute 'g/' .. l:BLANK_PATTERN .. '/delete'
            return
        elseif (a:line_space <# 0) || (1 + a:line_space ># l:LAST_LINE)
            return
        endif

        " 1. Search text lines forwards, starting from the beginning.
        " 2. For every text line, mark itself and following `a:line_space`
        " lines.
        execute 1
        if !search(l:TEXT_PATTERN, 'c', l:LAST_LINE - a:line_space)
            return
        endif
        const l:FIRST_LINE = line('.')
        execute l:FIRST_LINE .. ',$-' .. a:line_space .. 'g/' .. l:TEXT_PATTERN
                \ .. '/.,.+' .. a:line_space .. 's/$/' .. l:PLACEHOLDER .. '/'

        " 3. Mark leading blank lines.
        if l:FIRST_LINE ># a:line_space
            execute l:FIRST_LINE - a:line_space .. ',' l:FIRST_LINE .. 's/$/' ..
                    \ l:PLACEHOLDER .. '/'
        else
            execute '1,' l:FIRST_LINE .. 's/$/' .. l:PLACEHOLDER .. '/'
        endif

        " 4. Delete unmarked blank lines.
        if search(l:BLANK_PATTERN)
            execute 'g/' .. l:BLANK_PATTERN .. '/delete'
        endif
        " 5. Delete trainling placeholders.
        if search(l:DELETE_TRAIL)
            execute '%s/' .. l:DELETE_TRAIL .. '//'
        endif
    endfunction


    function! l:dict_func['_AddLastBlankLine']() abort
        if getline(line('$')) =~# '\v^\s*$'
            return
        endif
        $s/\v$/\r
    endfunction


    function! l:dict_func['outl']() abort
        %left 0
        call self['_DeleteTrailSpace']()
        call self['_DeleteBlankLine'](2)
        call self['_AddLastBlankLine']()
    endfunction


    function! l:dict_func['vim']() abort
        call self['_DeleteTrailSpace']()
        call self['_DeleteBlankLine'](2)
        call self['_AddLastBlankLine']()
    endfunction


    function! l:dict_func['loc']() abort
        setlocal fileencoding=utf-8
        setlocal fileformat=unix
        %s/\r//ge
        call <sid>LocalizationHelper('JoinLine')
    endfunction


    function! l:dict_func['markdown']() abort
        call self['_DeleteTrailSpace']()
        call self['_DeleteBlankLine'](3)
        call self['_AddLastBlankLine']()
    endfunction


    function! l:dict_func['text']() abort
        call self['_DeleteTrailSpace']()
        call self['_DeleteBlankLine'](3)
        call self['_AddLastBlankLine']()
    endfunction


    const l:FILE_TYPE = &filetype
    call <sid>SaveRestoreView(0)
    call <sid>InsertTimeStamp()
    if has_key(l:dict_func, l:FILE_TYPE)
        call l:dict_func[l:FILE_TYPE]()
    else
        call l:dict_func['_DeleteTrailSpace']()
        call l:dict_func['_DeleteBlankLine'](a:line_space)
    endif
    call <sid>SaveRestoreView(1)
endfunction


function! s:LocalizationHelper(helper, ...) abort
    let l:dict_func = {}
    let l:dict_func['DEBUG'] = 0

    let l:dict_func['OPT_ARG'] = a:000
    let l:dict_func['ARG_COUNT'] = a:0
    let l:dict_func['LOC_FILE'] = s:LOC_FILE
    let l:dict_func['OUTPUT'] = [<sid>GetTempFile('loc', 0),
            \ <sid>GetTempFile('loc', 1)]
    let l:dict_func['MARK_LABEL'] = '#MARK#'
    let l:dict_func['END_LABEL'] = '#END#'
    let l:dict_func['CR_LABEL'] = '#CR#'

    lockvar! l:dict_func['DEBUG']
    lockvar! l:dict_func['OPT_ARG']
    lockvar! l:dict_func['ARG_COUNT']
    lockvar! l:dict_func['LOC_FILE']
    lockvar! l:dict_func['OUTPUT']
    lockvar! l:dict_func['MARK_LABEL']
    lockvar! l:dict_func['END_LABEL']
    lockvar! l:dict_func['CR_LABEL']


    function! l:dict_func['_SearchFile'](text, search_file, output_file) abort
        let l:command = 'grep -i ' .. <sid>EscapeString(a:text, 2) .. ' '
                \ .. a:search_file
        if a:output_file !=# ''
            let l:command = l:command .. ' > ' .. a:output_file
            call system(l:command)
        endif
        return l:command
    endfunction


    function! l:dict_func['_HasFullSnippet']() abort
        return exists('s:LocalizationHelper_source')
                \ && exists('s:LocalizationHelper_target')
                \ && (s:LocalizationHelper_source !=# '')
                \ && (s:LocalizationHelper_target !=# '')
    endfunction


    function! l:dict_func['_InsertGlossary']() abort
        const l:SHORT_PATTERN = '\v\C^(([^\t]{-1,}\t){2})([^\t]*)$'
        const l:LONG_PATTERN = '\v\C^(([^\t]{-1,}\t){3})[^\t]*$'
        const l:CURRENT_LINE = getline(line('.'))

        if l:CURRENT_LINE =~# l:LONG_PATTERN
            execute 's/' .. l:LONG_PATTERN .. '/\1DEL/'
            return
        endif
        if l:CURRENT_LINE !~# l:SHORT_PATTERN
            if self['_HasFullSnippet']()
                put = s:LocalizationHelper_source .. '	'
                        \ .. s:LocalizationHelper_target .. '	'
            endif
            return
        endif

        const l:TYPE = [
            \ 'NPC',
            \ 'Location',
            \ 'Item',
            \ 'Skill \& Trait',
            \ 'General',
        \ ]
        const l:CURRENT_TYPE = <sid>EscapeString(
                \ substitute(l:CURRENT_LINE, l:SHORT_PATTERN, '\3', ''), 1)
        const l:CURRENT_INDEX = index(l:TYPE, l:CURRENT_TYPE)
        if (l:CURRENT_INDEX ==# -1) || (l:CURRENT_INDEX + 1) >=# len(l:TYPE)
            const l:NEW_TYPE = l:TYPE[0]
        else
            const l:NEW_TYPE = l:TYPE[l:CURRENT_INDEX + 1]
        endif
        execute 's/' .. l:SHORT_PATTERN .. '/\1' .. l:NEW_TYPE .. '/'
    endfunction


    function! l:dict_func['_InsertSnippet']() abort
        const l:PATTERN = '\v\t([^\t]{-})\t'
        const l:SOURCE = <sid>EscapeString(s:LocalizationHelper_source, 0)
        const l:TARGET = <sid>EscapeString(s:LocalizationHelper_target, 1)
        const l:EOL = "\n"
        unsilent const l:INPUT = input('Source: [' .. l:SOURCE .. ']' .. l:EOL
                \ .. 'Target: [' .. l:TARGET .. ']' .. l:EOL
                \ .. '[I]nsert|[A]ppend text, [C]opy command '
                \ )

        call <sid>SaveRestoreView(0)
        const l:START_LINE = line('.')
        execute 'normal! ]z'
        const l:END_LINE = line('.')
        const l:INSERT_SNIPPET = l:START_LINE .. ',' .. l:END_LINE .. 'g/'
                \ .. l:SOURCE .. '/s/' .. l:PATTERN
                \ .. '/\t' .. l:TARGET .. '\1\t/'
        const l:APPEND_SNIPPET = l:START_LINE .. ',' .. l:END_LINE .. 'g/'
                \ .. l:SOURCE .. '/s/' .. l:PATTERN
                \ .. '/\t\1' .. l:TARGET .. '\t/'

        if l:INPUT =~# 'i'
            if l:INPUT =~# 'c'
                let @" = l:INSERT_SNIPPET
            endif
            execute l:INSERT_SNIPPET
        elseif l:INPUT =~# 'a'
            if l:INPUT =~# 'c'
                let @" = l:APPEND_SNIPPET
            endif
            execute l:APPEND_SNIPPET
        elseif l:INPUT =~# 'c'
            let @" = l:INSERT_SNIPPET
        endif
        call <sid>SaveRestoreView(1)
    endfunction


    function! l:dict_func['InsertSnippetOrGlossary']() abort
        const l:GLOSSARY_PATTERN = 'Glossary {{{'
        if search(l:GLOSSARY_PATTERN, 'bcnW')
            call self['_InsertGlossary']()
        elseif self['_HasFullSnippet']()
            call self['_InsertSnippet']()
        endif
    endfunction


    function! l:dict_func['ResetCursorPosition']() abort
        const l:MARK = '\v\C' .. self['MARK_LABEL']
        const l:LONG_LINE = l:MARK .. '\t[^\t]+\t'
        const l:SHORT_LINE = '\v\C^[^\t]+\t'
        const l:TEXT = getline('.')

        if l:TEXT =~# l:LONG_LINE
            execute 'normal! ^'
            call search(l:MARK, 'c', line('.'))
            execute 'normal! 2f	l'
        elseif l:TEXT =~# l:SHORT_LINE
            execute 'normal! ^f	l'
        endif
    endfunction


    function! l:dict_func['JoinLine']() abort
        const l:END = '\v\C\t' .. self['END_LABEL']
        const l:CR = self['CR_LABEL']
        if !search(l:END .. '$', 'cw')
            return
        endif
        execute 'g/\v\t"[^\t]*$/.,/' .. l:END .. '$/-1s/\v$/' .. l:CR .. '/'
        execute '%s/\v\C(' .. l:CR .. ')+$/' .. l:CR .. '/ge'
        execute 'g/' .. l:CR .. '$/.,/' .. l:END .. '$/join!'
    endfunction


    " `a:1`: MAP_MODE
    " `a:2`: REMOVE_ALL
    function! l:dict_func['RemoveLabel']() abort
        const l:MARK_OR_END = '\v\C\t(' .. self['MARK_LABEL'] .. '|'
                \ .. self['END_LABEL'] .. ')'
        const l:CR = '\v\C' .. self['CR_LABEL']
        const l:MAP_MODE = self['OPT_ARG'][0]
        const l:REMOVE_ALL = self['OPT_ARG'][1]
        const l:RANGE = l:MAP_MODE ? "'<,'>" : '.'

        call <sid>SaveRestoreView(0)
        if l:REMOVE_ALL
            execute l:RANGE .. 's/'.. l:MARK_OR_END .. '//ge'
        endif
        execute l:RANGE .. 's/' .. l:CR .. '/\r/ge'
        call <sid>SaveRestoreView(1)
    endfunction


    " `a:1`: MAP_MODE
    " `a:2`: SEARCH_FILE
    function! l:dict_func['MapSearchKey']() abort
        const l:MAP_MODE = self['OPT_ARG'][0]
        const l:SEARCH_FILE = self['OPT_ARG'][1]

        const l:TEXT = (l:MAP_MODE ==# 0) ? expand('<cword>') : @"
        const l:FILE = self['LOC_FILE'][l:SEARCH_FILE]
        const l:COMMAND = self['_SearchFile'](l:TEXT, l:FILE, self['OUTPUT'][0])
        let @" = self['DEBUG'] ? l:COMMAND : @"
        call self['JumpToOutputBuffer']()
    endfunction


    function! l:dict_func['SearchGUID']() abort
        const l:CURRENT_LINE = getline(line('.'))
        const l:GUID = substitute(l:CURRENT_LINE, '\v^.*-((\a|\d)+)$', '\1', '')
        if l:GUID ==# l:CURRENT_LINE
            return
        endif
        let @" = l:GUID
        call <sid>LocalizationHelper('MapSearchKey', 1, 1)
    endfunction


    " `a:1`: MAP_MODE
    function! l:dict_func['FilterSearchResult']() abort
        const l:MARK = '\v\C' .. self['MARK_LABEL']
        const l:SEARCH = expand('<cword>')
        if !self['JumpToOutputBuffer']()
            return
        endif
        call self['JoinLine']()
        " Search the updated file.
        update

        const l:MAP_MODE = self['OPT_ARG'][0]
        if l:MAP_MODE ==# 2
            execute 'g/' .. l:MARK .. '\t[^\t]{-}\t\t/delete'
        else
            const l:TEXT = (l:MAP_MODE ==# 0) ? l:SEARCH : @"
            execute 'g!/' .. <sid>EscapeString(l:TEXT, 0) .. '/delete'
        endif
        execute 1
    endfunction


    " `a:1`: MAP_MODE
    function! l:dict_func['CopyGlossary']() abort
        const l:MAP_MODE = self['OPT_ARG'][0]

        if !exists('s:LocalizationHelper_source')
            let s:LocalizationHelper_source = ''
        endif
        if !exists('s:LocalizationHelper_target')
            let s:LocalizationHelper_target = ''
        endif

        if l:MAP_MODE ==# 0
            const l:CURRENT_LINE = getline(line('.'))
            const l:LONG_PATTERN = '\v^.{-}' .. self['MARK_LABEL'] ..
                    \ '\t([^\t]{-})\t([^]t]{-})\t.{-}'.. self['END_LABEL']
                    \ .. '$'
            const l:SHORT_PATTERN = '\v^([^\t]{-})\t([^\t]{-})\t.*$'
            if l:CURRENT_LINE =~# l:LONG_PATTERN
                const l:PATTERN = l:LONG_PATTERN
            elseif l:CURRENT_LINE =~# l:SHORT_PATTERN
                const l:PATTERN = l:SHORT_PATTERN
            else
                return
            endif
            let s:LocalizationHelper_source = substitute(l:CURRENT_LINE,
                    \ l:PATTERN, '\1', '')
            let s:LocalizationHelper_target = substitute(l:CURRENT_LINE,
                    \ l:PATTERN, '\2', '')
        elseif l:MAP_MODE ==# 1
            const l:EOL = "\n"
            unsilent const l:INPUT = input(
                    \ 'Source A: ' .. s:LocalizationHelper_source .. l:EOL
                    \ .. 'Target B: ' .. s:LocalizationHelper_target .. l:EOL
                    \ .. 'Register ": ' .. @" .. l:EOL
                    \ .. 'Overwrite [A|B], [S]wap A & B '
                    \ )
            if l:INPUT =~# 'a'
                let s:LocalizationHelper_source = @"
            endif
            if l:INPUT =~# 'b'
                let s:LocalizationHelper_target = @"
            endif
            if l:INPUT =~# 's'
                const l:TEMP_SAVE = s:LocalizationHelper_source
                let s:LocalizationHelper_source = s:LocalizationHelper_target
                let s:LocalizationHelper_target = l:TEMP_SAVE
            endif
        else
            unsilent echom 'Source: [' .. s:LocalizationHelper_source .. ']'
            unsilent echom 'Target: [' .. s:LocalizationHelper_target .. ']'
        endif
    endfunction


    function! l:dict_func['QuickCopy']() abort
        call <sid>SaveRestoreView(0)
        call self['ResetCursorPosition']()
        execute 'normal! yt	'
        call <sid>SaveRestoreView(1)
    endfunction


    function! l:dict_func['JumpToOutputBuffer']() abort
        if <sid>JumpToWindowByName(self['OUTPUT'][1])
            "execute 1
            return 1
        endif
        return 0
    endfunction


    if has_key(l:dict_func, a:helper)
        if l:dict_func['DEBUG']
            call l:dict_func[a:helper]()
        else
            silent call l:dict_func[a:helper]()
        endif
    endif
endfunction


" show_mode: 0: jump to window; 1: overwrite current buffer; 2: split window.
function! s:JumpToWindowByName(buffer_name, is_equal = 0, show_mode = 0) abort
    let l:dict_func = {}


    function! l:dict_func['_MatchBuffer'](this_buffer, match_buffer, is_equal)
            \ abort
        if a:is_equal
            return a:this_buffer ==# a:match_buffer
        else
            return a:this_buffer =~# a:match_buffer
        endif
    endfunction


    function! l:dict_func['_JumpToWindow'](match_buffer, is_equal) abort
        for l:i in range(1, winnr('$'))
            let l:buffer_name = bufname(winbufnr(l:i))
            if self['_MatchBuffer'](l:buffer_name, a:match_buffer, a:is_equal)
                execute l:i 'wincmd w'
                return 1
            endif
        endfor
        return 0
    endfunction


    function! l:dict_func['_OpenBuffer'](match_buffer, is_equal, show_mode)
            \ abort
        for l:i in getbufinfo()
            let l:buffer_number = l:i['bufnr']
            let l:buffer_name = bufname(l:buffer_number)
            if self['_MatchBuffer'](l:buffer_name, a:match_buffer, a:is_equal)
                if a:show_mode ==# 1
                    execute 'buffer ' .. l:buffer_number
                else
                    execute 'sbuffer ' .. l:buffer_number
                endif
                return 1
            endif
        endfor
        return 0
    endfunction


    if a:show_mode ==# 0
        return l:dict_func['_JumpToWindow'](a:buffer_name, a:is_equal)
    else
        return l:dict_func['_OpenBuffer'](a:buffer_name, a:is_equal,
                \ a:show_mode)
    endif
endfunction


" escape_mode: 0: search pattern; 1: substitution; 2: shell.
function! s:EscapeString(input, escape_mode) abort
    if a:escape_mode ==# 0
        return '\V\c' .. escape(a:input, '\/')
    elseif a:escape_mode ==# 1
        return escape(a:input, '\/~&')
    elseif a:escape_mode ==# 2
        return shellescape(a:input, 1)
    endif
    return a:input
endfunction


function! s:GetTempDirctory() abort
    return s:IS_WINDOWS ? $TEMP : '/var/tmp'
endfunction


function! s:GetTempFile(file_type, file_name_only = 0) abort
    const l:FILE_NAME = 'tmp.' .. a:file_type

    if a:file_name_only
        return l:FILE_NAME
    else
        return expand(<sid>GetTempDirctory() .. '/' .. l:FILE_NAME)
    endif
endfunction


" }}}1


" +========= SCRATCH PAD =========+
" +--------- ### ---------+

" getftype()
"
"lcd d:\GitHub\GhostInTheSwamp\
"echo system('git show-branch')

