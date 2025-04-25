vim9script

import autoload 'outline.vim' as OL


setlocal statusline=%!g:MyStatusLine(3,2)
setlocal bufhidden=hide
setlocal noswapfile
setlocal nobuflisted


nnoremap <buffer> <silent> <cr>
        \ :call <sid>OL.SearchText(v:false, v:false)<cr>
vnoremap <buffer> <silent> <cr>
        \ y:call <sid>OL.SearchText(v:true, v:false)<cr>

nnoremap <buffer> <silent> <leader><cr>
        \ :call <sid>OL.SearchText(v:false, v:true)<cr>
vnoremap <buffer> <silent> <leader><cr>
        \ y:call <sid>OL.SearchText(v:true, v:true)<cr>


augroup outline
    autocmd!
    autocmd BufWinEnter <buffer> setlocal nobuflisted
    autocmd BufEnter <buffer> silent edit
    autocmd BufLeave <buffer> silent update
augroup END

