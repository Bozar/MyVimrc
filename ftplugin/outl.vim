vim9script

import autoload 'temp_buffer.vim' as TB


setlocal statusline=%!g:MyStatusLine(3,2)
if TB.IsInTempFolder()
    setlocal noswapfile
endif

