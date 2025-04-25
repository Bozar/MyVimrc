vim9script

import autoload 'buffer_list.vim' as BL


setlocal nonumber
setlocal statusline=%!g:MyStatusLine(3,3)


nnoremap <buffer> <silent> <cr>
        \ :call <sid>BL.OpenWindow(1, 1)<cr>
nnoremap <buffer> <silent> o
        \ :call <sid>BL.OpenByPrompt()<cr>
nnoremap <buffer> <silent> i
        \ :call <sid>BL.OpenTab()<cr>

nnoremap <buffer> <silent> u
        \ :call <sid>BL.UpdateBuffer()<cr>
nnoremap <buffer> <silent> d
        \ :call <sid>BL.DeleteBuffer()<cr>
        \ :call <sid>BL.RefreshBufferList()<cr>


augroup buffer_list
    autocmd!
    autocmd BufEnter <buffer> BL.RefreshBufferList()
augroup END

