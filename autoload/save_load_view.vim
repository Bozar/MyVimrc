vim9script


const COUNT: number = 0
const FOLD: number = 1
const WIN: number = 2
const REGISTER: number = 3


export def SaveLoadView(is_save: bool): void
    if !exists('b:SaveLoadView')
        final b:SaveLoadView: dict<any> = {}
        b:SaveLoadView[COUNT] = 0
    endif

    if is_save
        SaveView()
    else
        LoadView()
    endif
enddef


def SaveView(): void
    if b:SaveLoadView[COUNT] ==# 0
        b:SaveLoadView[FOLD] = &foldenable
        b:SaveLoadView[WIN] = winsaveview()
        b:SaveLoadView[REGISTER] = @"
        setlocal nofoldenable
    endif
    b:SaveLoadView[COUNT] += 1
enddef


def LoadView(): void
    if b:SaveLoadView[COUNT] ># 0
        b:SaveLoadView[COUNT] -= 1
    endif
    if b:SaveLoadView[COUNT] ==# 0
        &foldenable = b:SaveLoadView[FOLD]
        winrestview(b:SaveLoadView[WIN])
        @" = b:SaveLoadView[REGISTER]
        unlet b:SaveLoadView
    endif
enddef

