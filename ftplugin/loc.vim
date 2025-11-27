vim9script


import autoload 'temp_file.vim' as TF
import autoload 'loc.vim' as LC
import autoload 'npad.vim' as NP


const TMP_FILE: string = TF.GetTempFileName(TF.LOC, TF.DEFAULT_NAME, v:false)
const TMP_FILE_FULL: string = TF.GetTempFileName(TF.LOC)


if expand('%') ==# TMP_FILE_FULL
	setlocal statusline=%!g:MyStatusLine(3,4)
	setlocal bufhidden=hide
	setlocal noswapfile
	setlocal nobuflisted
endif


augroup temp_loc
	autocmd!
	execute 'autocmd BufEnter ' .. TMP_FILE .. ' setlocal nobuflisted'
	execute 'autocmd BufEnter ' .. TMP_FILE .. ' silent edit'
	execute 'autocmd BufLeave ' .. TMP_FILE .. ' setlocal nobuflisted'
	execute 'autocmd BufLeave ' .. TMP_FILE .. ' silent update'
augroup END


nnoremap <buffer> <silent> <leader>jh
		\ :call <sid>TF.GotoTempWindow(
		\<sid>TF.LOC, <sid>TF.DEFAULT_NAME, v:false
		\)<cr>

nnoremap <buffer> <silent> <leader>fc
		\ :call <sid>LC.LoadSearchFile(v:true)<cr>

nnoremap <buffer> <silent> <cr>
		\ :call <sid>LC.ResetCursorPosition()<cr>
nnoremap <buffer> <silent> <c-cr>
		\ :call <sid>LC.QuickCopy()<cr>

# NOTE: There must be a space before the first line break, but no space before
# following lines. Otherwise one or more extra spaces will be insterted.
#
# nno <f1>
#		\:command_1<cr>
# WRONG: nno <f1>:command_1<cr>
#
# nno <f1>
#		\ :command_1<cr>
#		\ :command_2<cr>
# WRONG: nno <f1> :command_1<cr> :command_2<cr>

nnoremap <buffer> <silent> <f1>
		\ :update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_NORMAL, <sid>LC.FILE_GL
		\)<cr>
vnoremap <buffer> <silent> <f1>
		\ y:update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_VISUAL, <sid>LC.FILE_GL
		\)<cr>


nnoremap <buffer> <silent> <f2>
		\ :update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_NORMAL, <sid>LC.FILE_RF
		\)<cr>
vnoremap <buffer> <silent> <f2>
		\ y:update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_VISUAL, <sid>LC.FILE_RF
		\)<cr>

nnoremap <buffer> <silent> <s-f2>
		\ :call <sid>LC.SearchGUID()<cr>


nnoremap <buffer> <silent> <f3>
		\ :call <sid>LC.FilterSearchResult(<sid>LC.MAP_NORMAL)<cr>
vnoremap <buffer> <silent> <f3>
		\ y:call <sid>LC.FilterSearchResult(<sid>LC.MAP_VISUAL)<cr>

#nnoremap <buffer> <silent> <s-f3>
		#\ :call <sid>LC.FilterSearchResult(<sid>LC.MAP_NORMAL_SHIFT)<cr>
vnoremap <buffer> <silent> <s-f3>
		\ y:call <sid>LC.FilterSearchResult(
		\<sid>LC.MAP_VISUAL_SHIFT
		\)<cr>


nnoremap <buffer> <silent> <f4>
		\ :call <sid>LC.CopySnippet(<sid>LC.MAP_NORMAL)<cr>
vnoremap <buffer> <silent> <f4>
		\ y:call <sid>LC.CopySnippet(<sid>LC.MAP_VISUAL)<cr>


nnoremap <buffer> <silent> <f5>
		\ :silent call <sid>LC.AddSnippet()<cr>
nnoremap <buffer> <silent> <s-f5>
		\ :silent call <sid>LC.AddSnippet(<sid>LC.MAP_NORMAL_SHIFT)<cr>


nnoremap <buffer> <silent> <f6>
		\ :call <sid>LC.RemoveLabel(<sid>LC.MAP_NORMAL, v:false)<cr>
vnoremap <buffer> <silent> <f6>
		\ <esc>:call <sid>LC.RemoveLabel(<sid>LC.MAP_VISUAL, v:false)<cr>

nnoremap <buffer> <silent> <s-f6>
		\ :call <sid>LC.RemoveLabel(<sid>LC.MAP_NORMAL, v:true)<cr>
vnoremap <buffer> <silent> <s-f6>
		\ <esc>:call <sid>LC.RemoveLabel(<sid>LC.MAP_VISUAL, v:true)<cr>


nnoremap <buffer> <silent> <f7>
		\ :update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_NORMAL, <sid>LC.FILE_AD
		\)<cr>
vnoremap <buffer> <silent> <f7>
		\ y:update<cr>
		\:call <sid>LC.SearchPattern(
		\<sid>LC.MAP_VISUAL, <sid>LC.FILE_AD
		\)<cr>

