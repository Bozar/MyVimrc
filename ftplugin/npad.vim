vim9script

import autoload 'npad.vim' as NP
import autoload 'temp_file.vim' as TF


setlocal statusline=%!g:MyStatusLine(3,1)
setlocal bufhidden=hide
setlocal noswapfile
setlocal nobuflisted
setlocal foldmethod=marker


nnoremap <buffer> <silent> <cr>
		\ :call <sid>NP.SearchText(v:false, v:false)<cr>
vnoremap <buffer> <silent> <cr>
		\ y:call <sid>NP.SearchText(v:true, v:false)<cr>

nnoremap <buffer> <silent> <leader><cr>
		\ :call <sid>NP.SearchText(v:false, v:true)<cr>
vnoremap <buffer> <silent> <leader><cr>
		\ y:call <sid>NP.SearchText(v:true, v:true)<cr>

nnoremap <buffer> <silent> <leader>ff
		\ :call <sid>TF.SaveLoadText()<cr>

nnoremap <buffer> <silent> <leader>fc
		\ :call <sid>NP.ExecuteLine(v:true)<cr>
vnoremap <buffer> <silent> <leader>fc
		\ y:call <sid>NP.ExecuteLine(v:false)<cr>

nnoremap <buffer> <silent> <leader>fe
		\ :call <sid>NP.ArgaddLine(v:true)<cr>
vnoremap <buffer> <silent> <leader>fe
		\ <esc>:call <sid>NP.ArgaddLine(v:false)<cr>


augroup temp_npad
	autocmd!
	autocmd BufEnter <buffer> setlocal nobuflisted
	autocmd BufEnter <buffer> silent edit
	autocmd BufLeave <buffer> setlocal nobuflisted
	autocmd BufLeave <buffer> silent update
augroup END

