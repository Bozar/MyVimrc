vim9script


import autoload 'temp_file.vim' as TF
import autoload 'loc.vim' as LC


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


nnoremap <buffer> <silent> <leader>jh
        \ :call <sid>TF.GoToTempWindow(
        \       <sid>TF.LOC, <sid>TF.DEFAULT_NAME, v:false
        \       )<cr>

nnoremap <buffer> <silent> <cr>
        \ :call <sid>LC.ResetCursorPosition()<cr>
nnoremap <buffer> <silent> <c-cr>
        \ :call <sid>LC.QuickCopy()<cr>

nnoremap <buffer> <silent> <f1>
        \ :update<cr>
        \ :call <sid>LC.SearchPattern(<sid>LC.MAP_NORMAL, 0)<cr>
vnoremap <buffer> <silent> <f1>
        \ y:update<cr>
        \ :call <sid>LC.SearchPattern(<sid>LC.MAP_VISUAL, 0)<cr>

nnoremap <buffer> <silent> <f2>
        \ :update<cr>
        \ :call <sid>LC.SearchPattern(<sid>LC.MAP_NORMAL, 1)<cr>
vnoremap <buffer> <silent> <f2>
        \ y:update<cr>
        \ :call <sid>LC.SearchPattern(<sid>LC.MAP_VISUAL, 1)<cr>
nnoremap <buffer> <silent> <s-f2>
        \ :call <sid>LC.SearchGUID()<cr>

nnoremap <buffer> <silent> <f3>
        \ :call <sid>LC.FilterSearchResult(<sid>LC.MAP_NORMAL)<cr>
vnoremap <buffer> <silent> <f3>
        \ y:call <sid>LC.FilterSearchResult(<sid>LC.MAP_VISUAL)<cr>
nnoremap <buffer> <silent> <s-f3>
        \ :call <sid>LC.FilterSearchResult(<sid>LC.MAP_SHIFT)<cr>

