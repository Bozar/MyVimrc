vim9script

import autoload 'temp_file.vim' as TF


# TODO: Meger 'npad' into 'outl'.
nnoremap <silent> <unique> <leader>jl
        \ :silent call <sid>TF.GoToTempWindow('outl')<cr>
nnoremap <silent> <unique> <leader>jL
        \ :silent call <sid>TF.GoToTempBuffer('outl')<cr>

nnoremap <silent> <unique> <leader>ju
        \ :silent call <sid>TF.GoToTempBuffer(<sid>TF.BUFL)<cr>

