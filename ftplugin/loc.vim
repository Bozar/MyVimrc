vim9script


import autoload 'temp_file.vim' as TF


const TMP_FILE: string = TF.GetTempFileName(TF.LOC, TF.DEFAULT_NAME, v:false)
const TMP_FILE_FULL: string = TF.GetTempFileName(TF.LOC)


if expand('%') ==# TMP_FILE_FULL
    setlocal statusline=%!g:MyStatusLine(3,4)
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
endif


augroup temp_loc
    autocmd!
    execute 'autocmd BufEnter ' .. TMP_FILE .. ' setlocal nobuflisted'
    execute 'autocmd BufEnter ' .. TMP_FILE .. ' silent edit'
    execute 'autocmd BufLeave ' .. TMP_FILE .. ' setlocal nobuflisted'
    execute 'autocmd BufLeave ' .. TMP_FILE .. ' silent update'
augroup END

