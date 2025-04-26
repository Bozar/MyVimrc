vim9script

import autoload 'npad.vim' as NP


setlocal statusline=%!g:MyStatusLine(3,1)
setlocal bufhidden=hide
setlocal noswapfile
setlocal nobuflisted


nnoremap <buffer> <silent> <cr>
        \ :call <sid>NP.SearchText(v:false, v:false)<cr>
vnoremap <buffer> <silent> <cr>
        \ y:call <sid>NP.SearchText(v:true, v:false)<cr>

nnoremap <buffer> <silent> <leader><cr>
        \ :call <sid>NP.SearchText(v:false, v:true)<cr>
vnoremap <buffer> <silent> <leader><cr>
        \ y:call <sid>NP.SearchText(v:true, v:true)<cr>


augroup temp_npad
    autocmd!
    autocmd BufEnter <buffer> setlocal nobuflisted
    autocmd BufEnter <buffer> silent edit
    autocmd BufLeave <buffer> setlocal nobuflisted
    autocmd BufLeave <buffer> silent update
augroup END

