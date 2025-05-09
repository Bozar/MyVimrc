vim9script


const COUNT: number = 0
const FOLD: number = 1
const WIN: number = 2
const REGISTER: number = 3
const BUF_NR: number = 4

final SAVED_STATE: dict<any> = {}
SAVED_STATE[COUNT] = 0


# NOTE: SaveLoadState(v:true) & SaveLoadState(v:false) MUST BE called in pairs.
export def SaveLoadState(is_save: bool): void
	if is_save
		SaveState()
	else
		LoadState()
	endif
enddef


def SaveState(): void
	if SAVED_STATE[COUNT] ==# 0
		SAVED_STATE[BUF_NR] = bufnr()
		SAVED_STATE[FOLD] = &foldenable
		SAVED_STATE[WIN] = winsaveview()
		SAVED_STATE[REGISTER] = @"
		setlocal nofoldenable
	endif
	SAVED_STATE[COUNT] += 1
enddef


def LoadState(): void
	if SAVED_STATE[COUNT] ># 0
		SAVED_STATE[COUNT] -= 1
	endif
	if SAVED_STATE[COUNT] ==# 0
		if !bufexists(SAVED_STATE[BUF_NR])
			return
		endif
		execute ':' .. SAVED_STATE[BUF_NR] .. 'buffer'
		&foldenable = SAVED_STATE[FOLD]
		winrestview(SAVED_STATE[WIN])
		@" = SAVED_STATE[REGISTER]
	endif
enddef

