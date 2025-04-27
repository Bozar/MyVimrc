vim9script

import autoload 'markdown.vim' as MD


# :h ft-markdown-plugin
setlocal foldmethod=expr
setlocal foldexpr=g:MarkdownFold()


nnoremap <buffer> <silent> <leader>dc
        \ :silent call <sid>MD.InsertCodeBlock(0)<cr>
vnoremap <buffer> <silent> <leader>dc
        \ <esc>:silent call <sid>MD.InsertCodeBlock(1)<cr>

