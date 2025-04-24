vim9script

import autoload 'lib_vim.vim' as LV


setlocal statusline=%!g:MyStatusLine(3,0)
if LV.IsInTempFolder()
    setlocal noswapfile
endif

