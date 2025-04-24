vim9script

import autoload 'temp_file.vim' as TF


if TF.IsInTempFolder()
    setlocal statusline=%!g:MyStatusLine(3,4)
endif

