vim9script


import autoload 'save_load_view.vim' as SLV
import autoload 'temp_file.vim' as TF


export def SaveLoadText(): void
    const BACKUP_FILE: string = TF.GetTempFile('npad')
    unsilent const INPUT: string = input('[S]ave or [L]oad text? ')

    if INPUT ==# 's'
        SLV.SaveLoadView(v:true)
        const SAVE_BUFFER = bufnr()
        const SAVE_TEXT = getline(1, '$')
        execute 'edit! ' .. BACKUP_FILE
        :1put! = SAVE_TEXT
        :.+1,$g/^/delete
        write
        execute ':buffer ' .. SAVE_BUFFER
        SLV.SaveLoadView(v:false)

    elseif INPUT ==# 'l'
        if !filereadable(BACKUP_FILE)
            return
        endif
        put = readfile(BACKUP_FILE)
    endif
enddef

