vim9script

import autoload 'bufl.vim' as BL


setlocal nonumber
setlocal statusline=%!g:MyStatusLine(3,3)
# :h special-buffers
setlocal bufhidden=hide
setlocal noswapfile
setlocal nobuflisted


nnoremap <buffer> <silent> <cr>
        \ :call <sid>BL.OpenWindow(1, 1)<cr>
nnoremap <buffer> <silent> <leader><cr>
        \ :call <sid>BL.SplitOpenWindow()<cr>
nnoremap <buffer> <silent> o
        \ :call <sid>BL.OpenByPrompt()<cr>
nnoremap <buffer> <silent> i
        \ :call <sid>BL.OpenTab()<cr>

nnoremap <buffer> <silent> d
        \ :call <sid>BL.DeleteBuffer()<cr>
        \ :call <sid>BL.RefreshBufferList()<cr>


augroup temp_bufl
    autocmd!
    autocmd BufEnter <buffer> setlocal nobuflisted
    autocmd BufEnter <buffer> silent BL.RefreshBufferList()
augroup END

