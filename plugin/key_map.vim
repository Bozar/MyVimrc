vim9script


import autoload 'temp_file.vim' as TF
import autoload 'layout.vim' as LT


nnoremap <silent> <unique> <leader>jl
        \ :silent call <sid>TF.GoToTempWindow(<sid>TF.NPAD)<cr>
nnoremap <silent> <unique> <leader>jL
        \ :silent call <sid>TF.GoToTempBuffer(<sid>TF.NPAD)<cr>

nnoremap <silent> <unique> <leader>ju
        \ :silent call <sid>TF.GoToTempWindow(
        \       <sid>TF.BUFL, <sid>TF.DEFAULT_NAME, v:false
        \       )<cr>
nnoremap <silent> <unique> <leader>jU
        \ :silent call <sid>TF.GoToTempBuffer(<sid>TF.BUFL)<cr>


nnoremap <silent> <unique> <leader>xx
        \ :silent call <sid>LT.SplitWindow(<sid>LT.DEFAULT, v:false)<cr>
nnoremap <silent> <unique> <leader>xc
        \ :silent call <sid>LT.SplitWindow(<sid>LT.WIN_LUD, v:false)<cr>
nnoremap <silent> <unique> <leader>xz
        \ :silent call <sid>LT.SplitWindow(<sid>LT.LOC, v:false)<cr>

noremap <silent> <unique> <leader>zx
        \ :silent call <sid>LT.SplitWindow(<sid>LT.DEFAULT, v:true)<cr>
nnoremap <silent> <unique> <leader>zc
        \ :silent call <sid>LT.SplitWindow(<sid>LT.WIN_LUD, v:true)<cr>
nnoremap <silent> <unique> <leader>zz
        \ :silent call <sid>LT.SplitWindow(<sid>LT.LOC, v:true)<cr>

