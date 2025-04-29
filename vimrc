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

