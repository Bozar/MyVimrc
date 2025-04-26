vim9script


setlocal statusline=%!g:MyStatusLine(1)


augroup temp_qf
    autocmd!
    autocmd BufEnter <buffer> setlocal nobuflisted
augroup END

