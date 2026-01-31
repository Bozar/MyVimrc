vim9script

import autoload 'layout.vim' as LT
import autoload 'save_load_state.vim' as SLS
import autoload 'temp_file.vim' as TF


export def SplitOpenWindow(buf_nr: number): void
	if winnr('$') ==# 3
		:3wincmd w
		split
		TF.GotoTempWindow(TF.BUFL)
		LT.OpenWindow(buf_nr, 3, 3)
	elseif winnr('$') ==# 4
		LT.OpenWindow(buf_nr, 3, 3)
	else
		LT.OpenByPrompt(buf_nr)
	endif
enddef


# nomodifiable: cannot insert text; readonly: cannot save file.
# https://stackoverflow.com/questions/16680615/
export def RefreshBufferList(): void
	SLS.SaveLoadState(v:true)
	setlocal modifiable

	:%delete
	:1put = GetBufferList()
	:1delete
	update

	setlocal nomodifiable
	SLS.SaveLoadState(v:false)
enddef


# The function is not mapped by any key. I should update files outside buffer
# list to avoid mistakes.
export def UpdateBuffer(): void
	const BUFFER_NUMBER: number = GetBufferNumber()
	if (BUFFER_NUMBER <# 1) || getbufvar(BUFFER_NUMBER, '&readonly')
		return
	endif

	SLS.SaveLoadState(v:true)
	const SAVE_BUF_NR: number = bufnr()

	execute ':' .. BUFFER_NUMBER .. 'bufdo update'
	execute 'buffer ' .. SAVE_BUF_NR
	SLS.SaveLoadState(v:false)
enddef


export def DeleteBuffer(): void
	const BUFFER_NUMBER: number = GetBufferNumber()
	if (BUFFER_NUMBER <# 1)
		return
	endif
	execute 'bdelete ' .. BUFFER_NUMBER
enddef


export def GetBufferNumber(): number
	const CURRENT_LINE: string = getline('.')
	const PATTERN: string = '\v^\s*\[(\d+)\D*\].*'
	const STR_BUF_NR: string = substitute(CURRENT_LINE, PATTERN, '\1', '')
	if STR_BUF_NR ==# CURRENT_LINE
		return 0
	endif

	const NUM_BUF_NR: number = str2nr(STR_BUF_NR)
	if !bufexists(NUM_BUF_NR)
		return 0
	endif
	return NUM_BUF_NR
enddef


def GetBufferList(): list<string>
	var buffer_list: list<string> = []
	var buffer_number: number
	var last_path: string
	var file_name: string
	var buffer_changed: string
	var list_item: string
	for i: dict<any> in getbufinfo({'buflisted': 1})
		buffer_number = i['bufnr']
		last_path = expand('#' .. buffer_number .. ':p:h:t')
		file_name = expand('#' .. buffer_number .. ':t')
		buffer_changed = i['changed'] ? '+' : ''
		# Example: [3+] autoload/buffer_list.vim
		list_item = ' [' .. buffer_number .. buffer_changed .. '] '
				.. last_path .. '/' .. file_name
		add(buffer_list, list_item)
	endfor
	return buffer_list
enddef
