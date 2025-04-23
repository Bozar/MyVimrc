vim9script

import autoload 'temp_buffer.vim' as TB


if TB.IsInTempFolder()
    setlocal statusline=%!g:MyStatusLine(3,4)
endif

