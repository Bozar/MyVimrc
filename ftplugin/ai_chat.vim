vim9script

import autoload 'ai_chat.vim' as AI

nnoremap <buffer> <silent> <cr>
	\ :call <sid>AI.CopySnippet()<cr>
