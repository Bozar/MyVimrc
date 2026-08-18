vim9script

import autoload 'vocab.vim' as VB

nnoremap <buffer> <silent> <leader>fc
	\ :call <sid>VB.SwitchTab(v:true)<cr>
vnoremap <buffer> <silent> <leader>fc
	\ <esc>:call <sid>VB.SwitchTab(v:false)<cr>

nnoremap <buffer> <silent> <cr>
	\ :call <sid>VB.MoveCursor()<cr>
nnoremap <buffer> <silent> <c-cr>
	\ :call <sid>VB.CopyWord()<cr>
