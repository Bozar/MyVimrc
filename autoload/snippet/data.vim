vim9script


import autoload 'snippet/vim.vim' as VI
import autoload 'snippet/sh.vim' as SH
import autoload 'snippet/gdscript.vim' as GD
import autoload 'snippet/go.vim' as GO


export const INSERT_PLACEHOLDER: string = '%I%'
export const INDENT_PLACEHOLDER: string = '%S%'
export const DEFAULT_PLACEHOLDER: string = '%P%'

export const PATTERN_INSERT_PLACEHOLDER: string = '\V\C' .. INSERT_PLACEHOLDER
export const PATTERN_INDENT_PLACEHOLDER: string = '\V\C' .. INDENT_PLACEHOLDER
export const PATTERN_DEFAULT_PLACEHOLDER: string = '\V\C' .. DEFAULT_PLACEHOLDER

export final ABBREVIATION: dict<any> = {}
export final TEXT_BLOCK: dict<any> = {}
export final FIX_FILETYPE: dict<any> = {}


ABBREVIATION['vim'] = VI.ABBREVIATION
TEXT_BLOCK['vim'] = VI.TEXT_BLOCK

ABBREVIATION['sh'] = SH.ABBREVIATION
TEXT_BLOCK['sh'] = SH.TEXT_BLOCK

TEXT_BLOCK['gdscript'] = GD.TEXT_BLOCK
ABBREVIATION['gdscript'] = GD.ABBREVIATION

ABBREVIATION['go'] = GO.ABBREVIATION
TEXT_BLOCK['go'] = GO.TEXT_BLOCK

