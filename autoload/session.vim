vim9script


import autoload 'temp_file.vim' as TF
import autoload 'save_load_state.vim' as SLS


const FILE_NAME: string = TF.GetTempFileName('vim', 'session')


export def SaveSession(): void
	execute 'mksession! ' .. FILE_NAME
	nnoremap <f1> <Nop>
	unsilent echom 'Session saved: ' .. FILE_NAME
enddef


export def LoadSession(): void
	try
		execute 'source ' .. FILE_NAME
	catch /.*/
		execute 'Explore ' .. getcwd()
		execute 'throw ' .. v:exception
	endtry
enddef


export def SaveListedBuffer(): void
	const COMMAND_TAIL: string = '\ |:%argdelete'

	var command_list: list<string> = ['argedit']
	var file_name: string

	for i: dict<any> in getbufinfo({'buflisted': 1})
		file_name = expand('#' .. i['bufnr'] .. ':p')
		add(command_list, '\ ' .. file_name)
	endfor
	add(command_list, COMMAND_TAIL)

	SLS.SaveLoadState(v:true)
	writefile(command_list, FILE_NAME)
	SLS.SaveLoadState(v:false)
	nnoremap <f1> <Nop>
	unsilent echom	'Argedit command saved: ' .. FILE_NAME
enddef

