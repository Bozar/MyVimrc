vim9script

import autoload 'lib_vim.vim' as LV


if LV.IsInTempFolder()
    setlocal statusline=%!g:MyStatusLine(3,4)
endif

