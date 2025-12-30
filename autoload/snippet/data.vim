vim9script


import autoload 'snippet/vim.vim' as VI
import autoload 'snippet/sh.vim' as SH
import autoload 'snippet/gdscript.vim' as GD
import autoload 'snippet/go.vim' as GO
import autoload 'snippet/c.vim' as C
import autoload 'snippet/header.vim' as HD
import autoload 'snippet/python.vim' as PY


export const INSERT_PLACEHOLDER: string = '%I%'
export const INDENT_PLACEHOLDER: string = '%S%'
export const DEFAULT_PLACEHOLDER: string = '%P%'
export const LEFT_ALIGN_PLACEHOLDER: string = '%<%'

export const PATTERN_INSERT_PLACEHOLDER: string = '\V\C' .. INSERT_PLACEHOLDER
export const PATTERN_INDENT_PLACEHOLDER: string = '\V\C' .. INDENT_PLACEHOLDER
export const PATTERN_DEFAULT_PLACEHOLDER: string = '\V\C' .. DEFAULT_PLACEHOLDER
export const PATTERN_LEFT_ALIGN_PLACEHOLDER: string = '\V\C'
		.. LEFT_ALIGN_PLACEHOLDER

export final ABBREVIATION: dict<any> = {}
export final TEXT_BLOCK: dict<any> = {}
export final FIX_FILETYPE: dict<any> = {}


FIX_FILETYPE['h'] = 'header'


ABBREVIATION['vim'] = VI.ABBREVIATION
TEXT_BLOCK['vim'] = VI.TEXT_BLOCK

ABBREVIATION['sh'] = SH.ABBREVIATION
TEXT_BLOCK['sh'] = SH.TEXT_BLOCK

TEXT_BLOCK['gdscript'] = GD.TEXT_BLOCK
ABBREVIATION['gdscript'] = GD.ABBREVIATION

ABBREVIATION['go'] = GO.ABBREVIATION
TEXT_BLOCK['go'] = GO.TEXT_BLOCK

ABBREVIATION['c'] = C.ABBREVIATION
TEXT_BLOCK['c'] = C.TEXT_BLOCK

ABBREVIATION['header'] = HD.ABBREVIATION
TEXT_BLOCK['header'] = HD.TEXT_BLOCK

ABBREVIATION['python'] = PY.ABBREVIATION
TEXT_BLOCK['python'] = PY.TEXT_BLOCK

