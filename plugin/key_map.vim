vim9script


import autoload 'temp_file.vim' as TF
import autoload 'layout.vim' as LT
import autoload 'session.vim' as SS


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


# <f.> {{{1

# * <f1> is mapped to <Nop> in SS.LoadSession.
# * DO NOT use `:silent call ...`. There will be a prompt message when a swap
#   file exists.
nnoremap <silent> <unique> <f1>
        \ :call <sid>SS.LoadSession('<f1>')<cr>
nnoremap <silent> <unique> <f5>
        \ :silent call <sid>SS.SaveSession()<cr>

