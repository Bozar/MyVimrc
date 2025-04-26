vim9script


const TMP_FILE: string = 'tmp.loc'


if expand('%%:t') ==# TMP_FILE
    setlocal statusline=%!g:MyStatusLine(3,4)
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
endif


augroup temp_loc
    autocmd!
    execute 'autocmd BufEnter ' .. TMP_FILE .. 'setlocal nobuflisted'
    execute 'autocmd BufEnter ' .. TMP_FILE .. 'silent edit'
    execute 'autocmd BufLeave ' .. TMP_FILE .. 'setlocal nobuflisted'
    execute 'autocmd BufLeave ' .. TMP_FILE .. ' silent update'
augroup END

