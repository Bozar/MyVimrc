vim9script


const TMP_FILE: string = 'tmp.loc'


if expand('%%:t') ==# TMP_FILE
    setlocal statusline=%!g:MyStatusLine(3,4)
    setlocal noswapfile
endif


augroup localization
    autocmd!
    execute 'autocmd BufLeave ' .. TMP_FILE .. ' silent update'
augroup END

