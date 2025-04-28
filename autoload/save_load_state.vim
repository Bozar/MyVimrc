vim9script


const COUNT: number = 0
const FOLD: number = 1
const WIN: number = 2
const REGISTER: number = 3


export def SaveLoadState(is_save: bool): void
    if !exists('b:SaveLoadState')
        final b:SaveLoadState: dict<any> = {}
        b:SaveLoadState[COUNT] = 0
    endif

    if is_save
        SaveView()
    else
        LoadView()
    endif
enddef


def SaveView(): void
    if b:SaveLoadState[COUNT] ==# 0
        b:SaveLoadState[FOLD] = &foldenable
        b:SaveLoadState[WIN] = winsaveview()
        b:SaveLoadState[REGISTER] = @"
        setlocal nofoldenable
    endif
    b:SaveLoadState[COUNT] += 1
enddef


def LoadView(): void
    if b:SaveLoadState[COUNT] ># 0
        b:SaveLoadState[COUNT] -= 1
    endif
    if b:SaveLoadState[COUNT] ==# 0
        &foldenable = b:SaveLoadState[FOLD]
        winrestview(b:SaveLoadState[WIN])
        @" = b:SaveLoadState[REGISTER]
        unlet b:SaveLoadState
    endif
enddef

