vim9script

import autoload 'ai_chat.vim' as AI

nnoremap <buffer> <silent> <cr>
	\ :call <sid>AI.CopySnippet()<cr>

nnoremap <buffer> <silent> <leader>fc
	\ :call <sid>AI.AddLabel()<cr>

# NOTE:
# 1. Press `v` to enter visual mode. The line cannot be empty. Otherwise it may
# not work properly.
# 2. `s[<c-r>"]<esc>h`: Use `h` to move cursor back when the last character in
# the line is selected.
vnoremap <buffer> <silent> <leader>fc
	\ s[<c-r>"]<esc>h
	\ :call <sid>AI.AddLabel()<cr>
