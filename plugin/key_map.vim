vim9script


import autoload 'temp_file.vim' as TF
import autoload 'layout.vim' as LT
import autoload 'session.vim' as SS
import autoload 'power_search.vim' as PS
import autoload 'quick_command.vim' as QC
import autoload 'fold_marker.vim' as FM
import autoload 'tab_page.vim' as TP
import autoload 'format_text.vim' as FT
import autoload 'comment_text.vim' as CT


# f. {{{1

nnoremap <silent> <unique> <leader>fe
		\ :Explore<cr>

nnoremap <silent> <unique> <leader>fd
		\ :call <sid>FM.EditFoldMarker(&filetype)<cr>
nnoremap <silent> <unique> <leader>fg
		\ :call <sid>FT.AutoFormat()<cr>

nnoremap <silent> <unique> <leader>ff
		\ :update<cr>
nnoremap <silent> <unique> <leader>fa
		\ :wa<cr>
nnoremap <silent> <unique> <leader>fx
		\ :xa<cr>

nnoremap <silent> <unique> <leader>fl
		\ :left 0<cr>
vnoremap <silent> <unique> <leader>fl
		\ :left 0<cr>

nnoremap <silent> <unique> <leader>fc
		\ :call <sid>CT.AutoComment(&filetype, v:true)<cr>
vnoremap <silent> <unique> <leader>fc
		\ <esc>:call <sid>CT.AutoComment(&filetype, v:false)<cr>

nnoremap <silent> <unique> <leader>fh :setlocal hlsearch!<cr>

nnoremap <silent> <unique> <tab>
		\ :silent call <sid>PS.SearchHub(v:false)<cr>
vnoremap <silent> <unique> <tab>
		\ y:silent call <sid>PS.SearchHub(v:true)<cr>


# j. {{{1

nnoremap <silent> <unique> <leader>jl
		\ :silent call <sid>TF.GotoTempWindow(<sid>TF.NPAD)<cr>
nnoremap <silent> <unique> <leader>jL
		\ :silent call <sid>TF.GotoTempBuffer(<sid>TF.NPAD)<cr>

nnoremap <silent> <unique> <leader>ju
		\ :silent call <sid>TF.GotoTempWindow(
		\		<sid>TF.BUFL, <sid>TF.DEFAULT_NAME, v:false
		\		)<cr>
nnoremap <silent> <unique> <leader>jU
		\ :silent call <sid>TF.GotoTempBuffer(<sid>TF.BUFL)<cr>

nnoremap <silent> <unique> <leader>jh
		\ :silent 1wincmd w<cr>
		\:silent belowright copen<cr>

nnoremap <silent> <unique> <leader><space>
		\ :silent call <sid>LT.GotoPreviousWindow()<cr>
nnoremap <silent> <unique> <leader>jk
		\ :silent call <sid>LT.GotoLeftTopBottomWindow(v:true)<cr>
nnoremap <silent> <unique> <leader>jj
		\ :silent call <sid>LT.GotoLeftTopBottomWindow(v:false)<cr>


# x. {{{1

nnoremap <silent> <unique> <leader>xx
		\ :silent call <sid>LT.SplitWindow(<sid>LT.DEFAULT, v:false)<cr>
nnoremap <silent> <unique> <leader>xz
		\ :silent call <sid>LT.SplitWindow(<sid>LT.LOC, v:false)<cr>
nnoremap <silent> <unique> <leader>xc
		\ :silent call <sid>LT.SplitWindow(
		\<sid>LT.QUICK_FIX, v:false
		\)<cr>

noremap <silent> <unique> <leader>zx
		\ :silent call <sid>LT.SplitWindow(<sid>LT.DEFAULT, v:true)<cr>
nnoremap <silent> <unique> <leader>zz
		\ :silent call <sid>LT.SplitWindow(<sid>LT.LOC, v:true)<cr>
nnoremap <silent> <unique> <leader>zc
		\ :silent call <sid>LT.SplitWindow(
		\<sid>LT.QUICK_FIX, v:true
		\)<cr>


# <f.> {{{1

# * DO NOT use `:silent call ...`. There will be a prompt message when a swap
#	file exists.
nnoremap <silent> <unique> <f1>
		\ :call <sid>SS.LoadSession()<cr>
		\:nnoremap <f1> <Nop><cr>
inoremap <silent> <unique> <f1> <Nop>

nnoremap <silent> <unique> <f12>
		\ :silent call <sid>SS.SaveSession()<cr>
nnoremap <silent> <unique> <leader><f12>
		\ :silent call <sid>SS.SaveListedBuffer()<cr>


# Insert character {{{1

noremap! <unique> ,, *
noremap! <unique> ,. _
noremap! <unique> ,< <><left>

noremap! <unique> ( ()<left>
noremap! <unique> [ []<left>
noremap! <unique> { {}<left>

noremap! <unique> "" ""<left>
noremap! <unique> '' ''<left>
noremap! <unique> `` ``<left>

noremap! <unique> “” “”<left>
noremap! <unique> ‘’ ‘’<left>
noremap! <unique> （ （）<left>
noremap! <unique> 《 《》<left>
noremap! <unique> 【 【】<left>


# Misc mapping {{{1

# Because <tab> is mapped to power_search
nnoremap <unique> <c-h> <tab>
# Unmap <space>
map <unique> <space> <nop>
# Yank to the end of line
nnoremap <unique> Y y$
# Insert <tab> or <space> based on cursor position & preceeding characters.
#inoremap <silent> <unique> <tab> <esc>:call <sid>QC.InsertSmartTab()<cr>a


# `Entire line` text object
# https://www.reddit.com/r/vim/comments/6gjt02/fastest_way_to_copy_entire_line_without_the/
xnoremap <unique> il ^og_
# Use 'normal' instead of 'normal!' because 'il' should be remapped.
onoremap <silent> <unique> il :normal vil<CR>


# Jump to the marked position instead of line
noremap <unique> ' `


# Switch case
nnoremap <unique> ` ~
vnoremap <unique> ` ~


# Search backwards
nnoremap <unique> , ?
vnoremap <unique> , ?


# 0/-: First/last non-blank character in a line
# ^: First character in a line
noremap <unique> 0 ^
noremap <unique> - g_
noremap <unique> ^ 0


# Enter command-line mode.
nnoremap <unique> ; :
vnoremap <unique> ; :

# :h command-line-window
nnoremap <unique> <leader>; q:
vnoremap <unique> <leader>; q:

nnoremap <unique> <leader>/ q/


# Move in a line.
nnoremap <unique> <c-n> ;
nnoremap <unique> <c-p> ,

vnoremap <unique> <c-n> ;
vnoremap <unique> <c-p> ,


# Move between lines.
nnoremap <unique> <c-j> gj
nnoremap <unique> <c-k> gk

vnoremap <unique> <c-j> gj
vnoremap <unique> <c-k> gk


# Manage tab page
nnoremap <silent> <unique> <left>
		\ :silent call <sid>TP.GotoTabPage(v:false)<cr>
nnoremap <silent> <unique> <right>
		\ :silent call <sid>TP.GotoTabPage(v:true)<cr>
nnoremap <silent> <unique> <up>
		\ :silent call <sid>TP.MoveTabPage(v:false)<cr>
nnoremap <silent> <unique> <down>
		\ :silent call <sid>TP.MoveTabPage(v:true)<cr>
nnoremap <silent> <unique> <leader>zt
		\ :silent call <sid>TP.CloseTabPageToTheRight()<cr>

