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
    const s:OPEN_DESKTOP = get(s:PRIVATE_DATA, 'OPEN_DESKTOP', [])

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
    colorscheme default
endtry


" +--------- Settings Triggered by Auto-Commands ---------+ {{{3

augroup vimrc_setting
    autocmd!
    " Maximize window
    autocmd GUIEnter * call <sid>MaximizeWindow(s:IS_WINDOWS, s:IS_GUI)
    " Set background
    autocmd VimEnter * let &background = <sid>MyBackground()
    " Switch IME
    autocmd InsertLeave * call <sid>SwitchIme(0)
    autocmd InsertEnter * call <sid>SwitchIme(1)
augroup END


" +========= Key Mappings =========+ {{{2
" +--------- ### ---------+ {{{3

noremap! <unique> <c-s> *


" Yank to the end of line
nnoremap <unique> Y y$


" `Entire line` text object
" https://www.reddit.com/r/vim/comments/6gjt02/fastest_way_to_copy_entire_line_without_the/
xnoremap <unique> il ^og_
onoremap <silent> <unique> il :normal vil<CR>


" Jump to the marked position instead of line
noremap <unique> ' `


" Search backward.
nnoremap <unique> , ?
vnoremap <unique> , ?


" Switch case
nnoremap <unique> ` ~
vnoremap <unique> ` ~


" 0/-: First/last non-blank character in a line
" ^: First character in a line
noremap <unique> 0 ^
noremap <unique> - g_
noremap <unique> ^ 0


" Enter command-line mode.
nnoremap <unique> ; :
vnoremap <unique> ; :

" :h command-line-window
nnoremap <unique> <leader>; q:
vnoremap <unique> <leader>; q:

nnoremap <unique> <leader>/ q/


" Move in a line.
nnoremap <unique> <c-n> ;
nnoremap <unique> <c-p> ,

vnoremap <unique> <c-n> ;
vnoremap <unique> <c-p> ,


" Move between lines.
nnoremap <unique> <c-j> gj
nnoremap <unique> <c-k> gk

vnoremap <unique> <c-j> gj
vnoremap <unique> <c-k> gk


" Insert brackets.
noremap! <unique> ( ()<left>
noremap! <unique> [ []<left>
noremap! <unique> { {}<left>

noremap! <unique> “” “”<left>
noremap! <unique> ‘’ ‘’<left>
noremap! <unique> （ （）<left>
noremap! <unique> 《 《》<left>


" +--------- Custom actions ---------+ {{{3

nnoremap <silent> <unique> <leader>fe :Explore<cr>
nnoremap <silent> <unique> <leader>ff :update<cr>
nnoremap <silent> <unique> <leader>fa :wa<cr>
nnoremap <silent> <unique> <leader>fx :xa<cr>
nnoremap <silent> <unique> <leader>fr :resize 10<cr>


nnoremap <silent> <unique> <leader>fv :silent call <sid>ForkVim()<cr>
nnoremap <silent> <unique> <leader>fg :silent call <sid>FormatText()<cr>


nnoremap <silent> <unique> <leader>fh :call <sid>SwitchSetting('hlsearch')<cr>
nnoremap <silent> <unique> <leader>fm :call <sid>SwitchSetting('modifiable')<cr>


nnoremap <silent> <unique> <leader>fl :left 0<cr>
vnoremap <silent> <unique> <leader>fl :left 0<cr>


nnoremap <silent> <unique> <c-s-PageDown> :call <sid>MoveTabPage(1)<cr>
nnoremap <silent> <unique> <c-s-PageUp> :call <sid>MoveTabPage(0)<cr>
nnoremap <silent> <unique> <c-End> :call <sid>CloseTabPage()<cr>


nnoremap <silent> <unique> <leader>fs :silent call <sid>QuickSearch(0)<cr>
vnoremap <silent> <unique> <tab> y:silent call <sid>QuickSearch(1)<cr>


" Jump to a window
nnoremap <silent> <unique> <leader><space> :call <sid>JumpToPreviousWindow()<cr>
nnoremap <silent> <unique> <leader>jh
        \ :call <sid>JumpToScratchBuffer('npad', 0)<cr>
nnoremap <silent> <unique> <leader>jH
        \ :call <sid>JumpToScratchBuffer('npad', 1)<cr>

nnoremap <silent> <unique> <leader>ju
        \ :call <sid>JumpToScratchBuffer('bufl', 2)<cr>
nnoremap <silent> <unique> <leader>jU
        \ :call <sid>JumpToScratchBuffer('bufl', 1)<cr>

nnoremap <silent> <unique> <leader>jk :call <sid>JumpToWindowByPosition(0)<cr>
nnoremap <silent> <unique> <leader>jj :call <sid>JumpToWindowByPosition(1)<cr>
nnoremap <silent> <unique> <leader>jl
        \ :call <sid>JumpToWindowByName(<sid>GetTempFile('outl', 1))<cr>


" This key binding is hard-coded in `s:InitDesktop()`.
nnoremap <silent> <unique> <F1> :silent call <sid>InitDesktop()<cr>


" `[xz]?` - Split windows in the same tab or a new tab.
" `?[xz]` - Left width: 90 (x), 85 (z).
nnoremap <silent> <unique> <leader>xx :call <sid>SplitWindow(0, 0)<cr>
nnoremap <silent> <unique> <leader>xz :call <sid>SplitWindow(1, 0)<cr>

nnoremap <silent> <unique> <leader>zx :call <sid>SplitWindow(0, 1)<cr>
nnoremap <silent> <unique> <leader>zz :call <sid>SplitWindow(1, 1)<cr>


" Add a foldmarker. This map might be overwritten by a specific file type.
nnoremap <silent> <unique> <leader>df :silent call <sid>InsertFoldMarker()<cr>


" +========= Commands =========+ {{{2
" +--------- ### ---------+ {{{3

command -bar -nargs=0 CountCjkCharacter call <sid>CountCjkCharacter()
command -bar -nargs=? FormatText silent call <sid>FormatText(<f-args>)
command -bar -nargs=? ConvertFoldMarker
        \ silent call <sid>ConvertFoldMarker(<f-args>)

command -bar -nargs=* InsertTimeStamp call <sid>InsertTimeStamp(<f-args>)


" +--------- Auto Commands ---------+ {{{3

augroup auto_edit
    autocmd!
    autocmd BufEnter * call <sid>AutoHideBuffer()
    autocmd BufEnter * call <sid>AutoRefreshBuffer()
    " :h autocmd-nested
    autocmd BufLeave * ++nested silent call <sid>AutoSaveTempFile()
augroup END


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

function! s:InsertFoldMarker() abort
    execute 's/$/ {{{'
    execute 'normal! $'
endfunction


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


function! s:AutoHideBuffer() abort
    if <sid>IsScratchBuffer()
        setlocal nobuflisted
    endif
endfunction


function! s:AutoRefreshBuffer() abort
    if &filetype ==# 'bufl'
        silent call <sid>BufferListHelper('RefreshBufferList')
    endif
endfunction


function! s:AutoSaveTempFile() abort
    if <sid>IsInTempFolder()
        update
    endif
endfunction


function! s:IsInTempFolder() abort
    return expand('%:p') =~# <sid>EscapeString(
            \ expand(<sid>GetTempDirctory()), 1)
endfunction


function! s:IsScratchBuffer() abort
    return &buftype ==# 'nofile'
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


function! s:MoveTabPage(move_right) abort
    const l:CURRENT_TAB = tabpagenr()
    const l:LAST_TAB = tabpagenr('$')

    if a:move_right
        if l:CURRENT_TAB <# l:LAST_TAB
            const l:NEXT_TAB = '+1'
        else
            const l:NEXT_TAB = '0'
        endif
    else
        if l:CURRENT_TAB ># 1
            const l:NEXT_TAB = '-1'
        else
            const l:NEXT_TAB = '$'
        endif
    endif
    execute 'tabmove ' .. l:NEXT_TAB
endfunction


function! s:CloseTabPage() abort
    if tabpagenr('$') ># 1
        tabclose
    endif
endfunction


function! s:JumpToPreviousWindow() abort
    if winnr('$') ==# 1
        return
    endif

    const l:CURRENT_WINDOW = winnr()
    wincmd p
    if winnr() !=# l:CURRENT_WINDOW
        return
    endif

    const l:JUMP_TO_WINDOW = str2nr(input('Jump to window? '))
     if !<sid>IsValidWindowNumber(l:JUMP_TO_WINDOW)
         return
     endif
    execute l:JUMP_TO_WINDOW .. 'wincmd w'
endfunction


" 0: top left, 1: bottom left
function! s:JumpToWindowByPosition(row) abort
    if a:row ==# 0
        const l:NEXT_WINDOW = 1
    elseif a:row ==# 1
        1wincmd w
        const l:NEXT_WINDOW = winnr('99j')
        wincmd p
    else
        const l:NEXT_WINDOW = 1
    endif

    execute l:NEXT_WINDOW .. 'wincmd w'
endfunction


function! s:BufferListHelper(helper, ...) abort
    let l:dict_func = {}
    let l:dict_func['OPT_ARG'] = a:000
    let l:dict_func['ARG_COUNT'] = a:0
    lockvar! l:dict_func['OPT_ARG']
    lockvar! l:dict_func['ARG_COUNT']


    function! l:dict_func['_GetBufferList']() abort
        let l:buffer_list = []
        for l:i in getbufinfo({'buflisted': 1})
            let l:buffer_number = l:i['bufnr']
            let l:buffer_name = expand('#' .. l:buffer_number .. ':p:h:t')
                    \ .. '/' .. expand('#' .. l:buffer_number .. ':t')
            let l:buffer_changed = l:i['changed'] ? '+' : ''
            call add(l:buffer_list, ' [' .. l:buffer_number .. l:buffer_changed
                    \ .. '] ' .. l:buffer_name)
        endfor
        return l:buffer_list
    endfunction


    function! l:dict_func['_TryFixWinNumber'](this_win) abort
        return <sid>IsValidWindowNumber(a:this_win) ? a:this_win : 1
    endfunction


    function! l:dict_func['_GetBufferNumber']() abort
        const l:CURRENT_LINE = getline('.')
        const l:PATTERN =    '\v^\s*\[(\d+)\D*\].*'
        const l:GET_NUMBER = substitute(l:CURRENT_LINE, l:PATTERN, '\1', '')
        if l:GET_NUMBER ==# l:CURRENT_LINE
            return 0
        endif

        const l:BUFFER_NUMBER = str2nr(l:GET_NUMBER)
        if !bufexists(l:BUFFER_NUMBER)
            return 0
        endif
        return l:BUFFER_NUMBER
    endfunction


    function! l:dict_func['OpenByPrompt']() abort
        unsilent const l:INPUT = input('[Open|Jump] to window? ')
        const l:OPEN = str2nr(substitute(l:INPUT, '\v^\D*(\d+).*$', '\1', ''))
        const l:JUMP = str2nr(substitute(l:INPUT, '\v^\D*\d+\D+(\d+).*$', '\1',
                \ ''))
        call <sid>BufferListHelper('OpenBuffer', l:OPEN, l:JUMP)
    endfunction


    function! l:dict_func['OpenTab']() abort
        const l:BUFFER_NUMBER = self['_GetBufferNumber']()
        if l:BUFFER_NUMBER <# 1
            return
        endif
        const l:TAB_PAGE = tabpagenr()

        call <sid>SaveRestoreView(0)
        call <sid>SplitWindow(0, 1)
        tabmove $
        execute 'buffer ' .. l:BUFFER_NUMBER
        execute 'tabnext ' .. l:TAB_PAGE
        call <sid>SaveRestoreView(1)
    endfunction


    function! l:dict_func['OpenTabInBatch']() abort
        for l:i in range(line("'<"), line("'>"))
            execute l:i
            call self['OpenTab']()
        endfor
    endfunction


    " a1: l:OPEN_WINDOW = 1
    " a2: l:JUMP_WINDOW = 1
    function! l:dict_func['OpenBuffer']() abort
        const l:BUFFER_NUMBER = self['_GetBufferNumber']()
        if l:BUFFER_NUMBER <# 1
            return
        endif

        if self['ARG_COUNT'] <# 1
            const l:OPEN_WINDOW = 1
            const l:JUMP_WINDOW = 1
        elseif self['ARG_COUNT'] <# 2
            const l:OPEN_WINDOW = self['_TryFixWinNumber'](self['OPT_ARG'][0])
            const l:JUMP_WINDOW = self['_TryFixWinNumber'](self['OPT_ARG'][0])
        else
            const l:OPEN_WINDOW = self['_TryFixWinNumber'](self['OPT_ARG'][0])
            const l:JUMP_WINDOW = self['_TryFixWinNumber'](self['OPT_ARG'][1])
        endif

        execute l:OPEN_WINDOW .. 'wincmd w'
        execute 'buffer ' .. l:BUFFER_NUMBER
        execute l:JUMP_WINDOW .. 'wincmd w'
    endfunction


    " nomodifiable: cannot insert text; readonly: cannot save file.
    " https://stackoverflow.com/questions/16680615/
    function! l:dict_func['RefreshBufferList']() abort
        call <sid>SaveRestoreView(0)
        setlocal modifiable
        1,$delete
        1put = self['_GetBufferList']()
        1delete
        setlocal nomodifiable
        call <sid>SaveRestoreView(1)
    endfunction


    function! l:dict_func['UpdateBuffer']() abort
        const l:BUFFER_NUMBER = self['_GetBufferNumber']()
        if (l:BUFFER_NUMBER <# 1) || getbufvar(l:BUFFER_NUMBER, '&readonly')
            return
        endif
        call <sid>SaveRestoreView(0)
        const l:SAVE_BUFFER = bufnr()
        execute l:BUFFER_NUMBER .. 'bufdo update'
        execute 'buffer ' .. l:SAVE_BUFFER
        call <sid>SaveRestoreView(1)
    endfunction


    function! l:dict_func['UpdateBufferInBatch']() abort
        for l:i in range(line("'<"), line("'>"))
            execute l:i
            call self['UpdateBuffer']()
        endfor
    endfunction


    function! l:dict_func['DeleteBuffer']() abort
        const l:BUFFER_NUMBER = self['_GetBufferNumber']()
        if (l:BUFFER_NUMBER <# 1)
            return
        endif
        execute 'bdelete ' .. l:BUFFER_NUMBER
    endfunction


    function! l:dict_func['DeleteBufferInBatch']() abort
        for l:i in range(line("'<"), line("'>"))
            execute l:i
            call self['DeleteBuffer']()
        endfor
    endfunction


    if has_key(l:dict_func, a:helper)
        call l:dict_func[a:helper]()
    endif
endfunction


function! s:SetBufferKeyMap(file_type) abort
    let l:dict_func = {}


    function! l:dict_func['loc']() abort
        nnoremap <buffer> <silent> <cr>
                \ :call <sid>LocalizationHelper('ResetCursorPosition')<cr>
        nnoremap <buffer> <silent> <c-cr>
                \ :call <sid>LocalizationHelper('QuickCopy')<cr>
        inoremap <buffer> <silent> <c-cr> #CR#

        nnoremap <buffer> <silent> <leader>jt
                \ :call <sid>LocalizationHelper('JumpToOutputBuffer')<cr>

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


    function! l:dict_func['bufl']() abort
        nnoremap <buffer> <silent> <cr>
                \ :call <sid>BufferListHelper('OpenBuffer', 1, 1)<cr>
        nnoremap <buffer> <silent> o
                \ :call <sid>BufferListHelper('OpenByPrompt')<cr>

        nnoremap <buffer> <silent> i :call <sid>BufferListHelper('OpenTab')<cr>
        vnoremap <buffer> <silent> i
                \ y:call <sid>BufferListHelper('OpenTabInBatch')<cr>

        nnoremap <buffer> <silent> u
                \ :call <sid>BufferListHelper('UpdateBuffer')<cr>
        vnoremap <buffer> <silent> u
                \ <esc>:call <sid>BufferListHelper('UpdateBufferInBatch')<cr>

        nnoremap <buffer> <silent> d
                \ :call <sid>BufferListHelper('DeleteBuffer')<cr>
                \ :call <sid>BufferListHelper('RefreshBufferList')<cr>
        vnoremap <buffer> <silent> d
                \ <esc>:call <sid>BufferListHelper('DeleteBufferInBatch')<cr>
                \ :call <sid>BufferListHelper('RefreshBufferList')<cr>
    endfunction


    if has_key(l:dict_func, a:file_type)
        call l:dict_func[a:file_type]()
    endif
endfunction


function! s:CreateScratchBuffer(file_type = '') abort
    const l:TAB_PAGE = tabpagenr()
    tabnew
    const l:BUFFER_NUMBER = bufnr()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal statusline=%!g:MyStatusLine(1)

    if a:file_type !=# ''
        execute 'let &filetype = "' .. a:file_type .. '"'
    endif

    tabclose
    execute 'tabnext ' .. l:TAB_PAGE
    return l:BUFFER_NUMBER
endfunction


" Return a list of scratch buffers ordered by buffer numbers.
" [[buffer_number, file_type], ...]
function! s:ListScratchBuffer(file_type = '') abort
    let l:scratch_list = []
    let l:dict_func = {}


    function! l:dict_func['_MatchBuffer'](input, match_this) abort
        return (a:input ==# '') || (a:input ==# a:match_this)
    endfunction


    for l:i in getbufinfo()
        let l:buffer_number = l:i['bufnr']
        if getbufvar(l:buffer_number, '&buftype') !=# 'nofile'
            continue
        endif

        let l:file_type = getbufvar(l:buffer_number, '&filetype')
        if l:dict_func['_MatchBuffer'](a:file_type, l:file_type)
            call add(l:scratch_list, [l:buffer_number, l:file_type,])
        endif
    endfor

    return l:scratch_list
endfunction


function! s:MyBackground() abort
    const l:LIGHT = 'light'
    const l:DARK = 'dark'

    " Do not switch background.
    " Always use light background. Auto completion menu is barely visible in
    " terminal with dark background.
    return l:LIGHT
    "return s:IS_GUI ? l:LIGHT : l:DARK

    "if s:SWITCH_BACKGROUND ==# 1
    "    return l:LIGHT
    "elseif s:SWITCH_BACKGROUND ==# 2
    "    return l:DARK
    "endif

    "if s:IS_GUI
    "    const l:HOUR = str2nr(strftime('%H'))
    "    if (l:HOUR ># s:TURN_ON_LIGHT) && (l:HOUR <# s:TURN_OFF_LIGHT)
    "        return l:LIGHT
    "    endif
    "endif
    "return l:DARK
endfunction


function! s:QuickSearch(add_to_register) abort
    let l:dict_func = {}


    function! l:dict_func['_SetVariable'](input, text) abort
        if a:input =~# 'a'
            call <sid>SetConstant('s:QuickSearch_PATTERN', a:text)
        endif
        if a:input =~# 'b'
            call <sid>SetConstant('s:QuickSearch_STRING', a:text)
        endif

        if a:input =~# 's'
            const l:TEMP_SAVE = s:QuickSearch_STRING
            call <sid>SetConstant('s:QuickSearch_STRING', s:QuickSearch_PATTERN)
            call <sid>SetConstant('s:QuickSearch_PATTERN', l:TEMP_SAVE)
        endif

        if a:input =~# 'd'
            call <sid>SetConstant('s:QuickSearch_STRING', '')
        endif
    endfunction


    function! l:dict_func['_QuickSubstitute'](input) abort
        const l:NEW_PATTERN = <sid>EscapeString(s:QuickSearch_PATTERN, 0)
        const l:NEW_STRING = <sid>EscapeString(s:QuickSearch_STRING, 1)
        const l:COMMAND = '%s/' .. l:NEW_PATTERN .. '/' .. l:NEW_STRING
                \ .. '/gce'

        if a:input =~# 'c'
            let @" = l:COMMAND
        endif
        if a:input =~# 'e'
            call <sid>SaveRestoreView(0)
            unsilent execute l:COMMAND
            call <sid>SaveRestoreView(1)
        endif
    endfunction


    function! l:dict_func['_GetPrompt']() abort
        call <sid>SetConstant('s:QuickSearch_STRING', '', 1)
        call <sid>SetConstant('s:QuickSearch_PATTERN', '', 1)

        const l:PATTERN = <sid>EscapeString(s:QuickSearch_PATTERN, 0)
        const l:SUBSTITUTE = <sid>EscapeString(s:QuickSearch_STRING, 1)
        const l:EOL = "\n"
        const l:INPUT = 'Pattern A: [' .. l:PATTERN .. ']' .. l:EOL
                \ .. 'String B: [' .. l:SUBSTITUTE .. ']' .. l:EOL
                \ .. 'Register ": [' .. @" .. ']' .. l:EOL
                \ .. 'Overwrite [A|B], [S]wap A & B, [D]elete B,' .. l:EOL
                \ .. '> [C]opy|[E]xecute command, [Y]ank all '
        return l:INPUT
    endfunction


    function! l:dict_func['_GetSearchResult'](pattern) abort
        const l:EOL = "\n"
        const l:COMMAND_OUTPUT = execute('%s/' .. a:pattern .. '//gne')
        const l:SEARCH_RESULT = (l:COMMAND_OUTPUT ==# '')
                \ ? 'Match: 0, Line: 0' .. l:EOL
                \ : substitute(l:COMMAND_OUTPUT, '\v^\D*(\d+)\D*(\d+)\D*$',
                \ 'Match: \1, Line: \2', '') .. l:EOL
        return l:SEARCH_RESULT
    endfunction


    function! l:dict_func['_YankAllText'](pattern) abort
        const l:this_buffer = bufnr()
        const l:TEMP_SAVE = @a
        let @a = ''
        execute 'g/' .. a:pattern .. '/normal! "Ayy'
        call <sid>JumpToScratchBuffer('npad', 1)
        $put = @a
        execute 'buffer ' .. l:this_buffer
        let @a = l:TEMP_SAVE
    endfunction


    " If `register "` has more than one lines, keep only the first one.
    const l:RAW_PATTERN = substitute(@", '\v([^\n]*)\n*.*', '\1', '')
    const l:ESCAPED_PATTERN = <sid>EscapeString(l:RAW_PATTERN, 0)
    " Call from visual mode.
    if a:add_to_register
        normal! `<
        let @/ = l:ESCAPED_PATTERN
    endif
    call <sid>SaveRestoreView(0)
    unsilent const l:INPUT = input(
            \ l:dict_func['_GetSearchResult'](l:ESCAPED_PATTERN)
            \ .. l:dict_func['_GetPrompt']()
            \ )
    call <sid>SaveRestoreView(1)

    if l:INPUT ==# ''
        return
    endif

    call l:dict_func['_SetVariable'](l:INPUT, l:RAW_PATTERN)
    if l:INPUT =~# 'y'
        call <sid>SaveRestoreView(0)
        call l:dict_func['_YankAllText'](l:ESCAPED_PATTERN)
        call <sid>SaveRestoreView(1)
    endif
    call l:dict_func['_QuickSubstitute'](l:INPUT)
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


" This function should only be called once when pressing <F1>.
function! s:InitDesktop() abort
    if len(s:OPEN_DESKTOP) ># 0
        for l:i in s:OPEN_DESKTOP
            call <sid>LoadProject(l:i)
        endfor
        tabnext 1
        redraw!
    endif
    nunmap <F1>
    nnoremap <silent> <unique> <F1> <nop>
endfunction


" `a:project_dict` is a list of dictionaries.
" [
"     {
"         'LOCAL_DIR': '',
"         'WIN_LAYOUT': -1,
"         'NEW_TAB': 0,
"         'SHOW_LINE': -1,
"         'SHOW_FILE': '',
"         'ARG_EDIT': ['', ...],
"     },
"     {...},
" ]

function! s:LoadProject(project_dict) abort
    const l:LOCAL_DIR = get(a:project_dict, 'LOCAL_DIR', '')
    const l:WIN_LAYOUT = get(a:project_dict, 'WIN_LAYOUT', -1)
    const l:NEW_TAB = get(a:project_dict, 'NEW_TAB', 0)
    const l:ARG_EDIT = get(a:project_dict, 'ARG_EDIT', [])
    const l:SHOW_FILE = get(a:project_dict, 'SHOW_FILE', '')
    const l:SHOW_LINE = get(a:project_dict, 'SHOW_LINE', -1)

    const l:SAVE_DIR = getcwd()
    if l:LOCAL_DIR !=# ''
        execute 'cd ' .. l:LOCAL_DIR
    endif

    call <sid>SplitWindow(l:WIN_LAYOUT, l:NEW_TAB)

    arglocal!
    for l:i in l:ARG_EDIT
        execute 'argedit ' .. l:i
    endfor
    if l:SHOW_FILE !=# ''
        execute 'argedit ' .. l:SHOW_FILE
    endif
    last
    %argdelete

    call <sid>TryJumpToMark('m', l:SHOW_LINE)
    execute 'cd ' .. l:SAVE_DIR
endfunction


function! s:TryJumpToMark(mark, height = 0) abort
    if line("'" .. a:mark) <# 1
        return
    endif

    const l:HALF_WIN_HEIGHT = winheight('') / 2
    execute 'normal! `' .. a:mark

    if a:height ==# 0
        if winline() ># l:HALF_WIN_HEIGHT
            execute 'normal! zz'
        endif
    elseif a:height ==# 1
        execute 'normal! zt'
    elseif (a:height ># 1) && (a:height <# l:HALF_WIN_HEIGHT)
        execute 'normal! zt'
        execute 'normal! ' .. a:height .. ''
    endif
endfunction


" https://vi.stackexchange.com/questions/21204/
function! g:MyTabLine()
    let l:result = ''
    const l:TAB_PREFIX = 'Tab #'

    for l:num in range(1, tabpagenr('$'))
        " Tab color
        let l:result ..= (l:num !=# tabpagenr())
                \ ? '%#TabLine#'
                \ : '%#TabLineSel#'
        " Tab text
        let l:result ..= '%' .. l:num .. 'T ' .. l:TAB_PREFIX .. l:num .. ' '
    endfor
    " Space filler
    let l:result ..= '%#TabLineFill#%T%='
    return l:result
endfunction


function! s:ForkVim() abort
    if s:IS_GUI
        !gvim
    endif
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


function! s:SwitchSetting(setting) abort
    let l:dict_func = {}


    function! l:dict_func['hlsearch']() abort
        setlocal hlsearch!
    endfunction


    function! l:dict_func['modifiable']() abort
        setlocal modifiable!
    endfunction


    if has_key(l:dict_func, a:setting)
        call l:dict_func[a:setting]()
    endif
endfunction


" :h digraph-table
function s:CountCjkCharacter()
    const l:PATTERN = '\v\C[^\x00-\xff]'
    const l:MESSAGE = 'CJK character(s): '
    const l:OUTPUT =    '\v\C^\D*(\d+).*'
    let l:count = '0'

    if search(l:PATTERN, 'n') ==# 0
        echom l:MESSAGE .. l:count
        return
    endif

    call <sid>SaveRestoreView(0)
    const l:COUNT = substitute(execute('silent %s/' .. l:PATTERN .. '//gn'),
            \ l:OUTPUT, '\1', '')
    echom l:MESSAGE .. l:COUNT
    call <sid>SaveRestoreView(1)
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


function! s:SplitWindow(layout, new_tab = 0)
    const l:INVALID_LAYOUT = -1
    const l:LEFT_COLUMN_WIDTH_NARROW = 85
    const l:LEFT_COLUMN_WIDTH = 90
    const l:RIGHT_BOTTOM_HEIGHT = 10
    const l:BUFFER_LIST_FILETYPE = 'bufl'
    const l:OUTLINE_FILE = <sid>GetTempFile('outl')
    const l:LOC_FILE = <sid>GetTempFile('loc')

    if a:new_tab
        tab split
    endif
    if (a:layout ># l:INVALID_LAYOUT) && (winnr('$') ># 1)
        wincmd o
    endif

    if a:layout ==# 0
        " Left window
        wincmd v
        execute 'vertical resize ' .. l:LEFT_COLUMN_WIDTH
        " Right upper window, [Note Pad]
        2wincmd w
        call <sid>JumpToScratchBuffer('npad', 1)
        " Right lower window, [Outline]
        wincmd s
        3wincmd w
        execute 'edit ' .. l:OUTLINE_FILE
        execute 'resize ' .. l:RIGHT_BOTTOM_HEIGHT
        " Back to window 1
        1wincmd w

    elseif a:layout ==# 1
        wincmd v
        execute 'vertical resize ' .. l:LEFT_COLUMN_WIDTH_NARROW
        2wincmd w
        execute 'edit ' .. l:LOC_FILE
        1wincmd w
    endif
endfunction


" 1. Find the first matched scratch buffer. If failed, create a new one.
" 2-1. `a:overwrite ==# 0`: Jump to a window that has the buffer, or open it in
" a new horizontal window.
" 2-2. `a:overwrite ==# 1`: Always open the buffer in current window.
" 2-3. `a:overwrite ==# 2`: Jump to a window that has the buffer, or open it in
" current window.
function! s:JumpToScratchBuffer(file_type = '', overwrite = 0) abort
    const l:SCRATCH_LIST = <sid>ListScratchBuffer(a:file_type)
    if len(l:SCRATCH_LIST) ># 0
        const l:BUFFER_NUMBER = l:SCRATCH_LIST[0][0]
    else
        const l:BUFFER_NUMBER = <sid>CreateScratchBuffer(a:file_type)
    endif

    if a:overwrite ==# 1
        execute 'buffer ' .. l:BUFFER_NUMBER
    else
        const l:WINDOW_NUMBER = bufwinnr(l:BUFFER_NUMBER)
        if l:WINDOW_NUMBER ># 0
            execute l:WINDOW_NUMBER .. 'wincmd w'
        else
            if a:overwrite ==# 0
                execute 'sbuffer ' .. l:BUFFER_NUMBER
            else
                execute 'buffer ' .. l:BUFFER_NUMBER
            endif
        endif
    endif
endfunction


function! s:MaximizeWindow(is_win, is_gui) abort
    if a:is_win
        simalt ~x
    elseif a:is_gui
        set guiheadroom=0
        winsize 123 31
    endif
endfunction


function! s:SwitchIme(switch_on) abort
    if s:IS_WINDOWS && s:IS_GUI
        if a:switch_on
            set noimdisable
            set iminsert=2
        else
            set imdisable
            set iminsert=0
        endif
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


function! s:ConvertFoldMarker(fold_marker_type = '') abort
    let l:dict_func = {}


    function! l:dict_func['_GetFoldMarkerType'](command_arg) abort
        let l:fold_marker_type = ''

        if a:command_arg ==# 'm'
            let l:fold_marker_type = 'm'
        elseif a:command_arg ==# 't'
            let l:fold_marker_type = 't'
        else
            " Convert to text file style fold markers.
            if &filetype ==# 'markdown'
                let l:fold_marker_type = 't'
            " Convert to markdown file style fold markers.
            elseif &filetype ==# 'text'
                let l:fold_marker_type = 'm'
            endif
        endif

        return l:fold_marker_type
    endfunction


    function! l:dict_func['_ConvertToMarkdown']() abort
        const l:FOLD_PATTERN = '\v \{{3}\d*$'

        if !search(l:FOLD_PATTERN, 'cw')
            return
        endif

        " Convert from text file.
        setlocal foldmethod=marker

        execute 'g/' .. l:FOLD_PATTERN .. '/s/^/ /'
        execute 'g/' .. l:FOLD_PATTERN .. '/s/^/\=repeat("#", foldlevel("."))'
        execute '%s/' .. l:FOLD_PATTERN .. '//'
    endfunction


    function! l:dict_func['_ConvertToText']() abort
        const l:FOLD_PATTERN = '\v^#+ '

        if !search(l:FOLD_PATTERN, 'cw')
            return
        endif

        " Convert from markdown file.
        setlocal foldmethod=expr
        setlocal foldexpr=MarkdownFold()

        execute 'g/' .. l:FOLD_PATTERN .. '/s/$/ {{{/'
        execute 'g/' .. l:FOLD_PATTERN .. '/s/$/\=foldlevel(".")/'
        execute '%s/' .. l:FOLD_PATTERN .. '//'
    endfunction


    const l:FOLD_MARKER_TYPE = l:dict_func['_GetFoldMarkerType'](
            \ a:fold_marker_type)
    if l:FOLD_MARKER_TYPE ==# ''
        return
    endif

    call <sid>SaveRestoreView(0)
    const l:SAVE_FOLD_ENABLE = &foldenable
    const l:SAVE_FOLD_METHOD = &foldmethod
    const l:SAVE_FOLD_EXPR = &foldexpr

    setlocal foldenable
    if l:FOLD_MARKER_TYPE ==# 'm'
        call l:dict_func['_ConvertToMarkdown']()
    elseif l:FOLD_MARKER_TYPE ==# 't'
        call l:dict_func['_ConvertToText']()
    endif

    if l:SAVE_FOLD_ENABLE
        setlocal foldenable
    else
        setlocal nofoldenable
    endif
    execute 'setlocal foldmethod=' .. l:SAVE_FOLD_METHOD
    execute 'setlocal foldexpr=' .. l:SAVE_FOLD_EXPR
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

"belowright copen

" getftype()
"
"lcd d:\GitHub\GhostInTheSwamp\
"echo system('git show-branch')

" :h **
" :h function-list

" s:BufferListHelper(helper, ...) abort
" Add an option to move a buffer to the top?

