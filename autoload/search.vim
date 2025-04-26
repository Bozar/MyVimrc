vim9script


export def GetPlainSearchText(text: string): string
    return '\V\c' .. escape(text, '\/')
enddef

