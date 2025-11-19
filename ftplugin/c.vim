vim9script

import autoload 'c.vim' as C


setlocal colorcolumn=81
setlocal nolinebreak


nnoremap <buffer> <silent> <leader>fd
		\ :call <sid>C.ExpandLine(v:false)<cr>
vnoremap <buffer> <silent> <leader>fd
		\ <esc>:call <sid>C.ExpandLine(v:true)<cr>

