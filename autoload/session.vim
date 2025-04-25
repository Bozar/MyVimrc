vim9script


import autoload 'temp_file.vim' as TF


const FILE_NAME: string = TF.GetTempFileName('vim', 'session')


export def SaveSession(): void
    execute 'mksession! ' .. FILE_NAME
    unsilent echom 'Session saved: ' .. FILE_NAME
enddef


export def LoadSession(load_key: string): void
    try
        execute 'source ' .. FILE_NAME
    catch /.*/
        execute 'Explore ' .. getcwd()
        execute 'throw ' .. v:exception
    finally
        execute 'nnoremap ' .. load_key .. ' <Nop>'
    endtry
enddef

