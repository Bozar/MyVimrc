vim9script

import autoload 'outline.vim' as OL
import autoload 'notepad.vim' as NP
import autoload 'temp_file.vim' as TF


setlocal statusline=%!g:MyStatusLine(3,0)
if TF.IsInTempFolder()
    setlocal noswapfile
endif


nnoremap <buffer> <silent> <leader>ff
        \ :silent call <sid>NP.SaveLoadText()<cr>

nnoremap <buffer> <silent> <cr>
        \ :call <sid>OL.SearchText(v:false, v:false)<cr>
vnoremap <buffer> <silent> <cr>
        \ y:call <sid>OL.SearchText(v:true, v:false)<cr>

nnoremap <buffer> <silent> <leader><cr>
        \ :call <sid>OL.SearchText(v:false, v:true)<cr>
vnoremap <buffer> <silent> <leader><cr>
        \ y:call <sid>OL.SearchText(v:true, v:true)<cr>

