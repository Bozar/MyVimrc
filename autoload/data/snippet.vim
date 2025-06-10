vim9script


export final ABBREVIATION: dict<any> = {}
export final TEXT_BLOCK: dict<any> = {}

export const INSERT_PLACEHOLDER: string = '%I%'
export const INDENT_PLACEHOLDER: string = '%S%'
export const DEFAULT_PLACEHOLDER: string = '%P%'

export const PATTERN_INSERT_PLACEHOLDER: string = '\V\C' .. INSERT_PLACEHOLDER
export const PATTERN_INDENT_PLACEHOLDER: string = '\V\C' .. INDENT_PLACEHOLDER
export const PATTERN_DEFAULT_PLACEHOLDER: string = '\V\C' .. DEFAULT_PLACEHOLDER


# vim {{{1

ABBREVIATION['vim'] = {
	'==': '==#',
	'!=': '!=#',
	'>>': '>#',
	'>=': '>=#',
	'<<': '<#',
	'<=': '<=#',
	'=~': '=~#',
	'!~': '!~#',
	'is;': 'is#',
	'isn;': 'isnot#',
	'ex;': 'execute',
}

TEXT_BLOCK['vim'] = {
	'jj;': [
		'vim9script',
		'',
		"#import auto '%I%' as",
		'',
		'',
	],
	'fuu;': [
		'export def %I%(): void',
		'%S%#BODY',
		'enddef',
	],
	'fu;': [
		'def %I%(): void',
		'%S%#BODY',
		'enddef',
	],
	'if;': [
		'if %I%',
		'#elseif',
		'#else',
		'endif',
	],
	'for;': [
		'for i: %P% in %I%',
		'endfor',
	],
	'whl;': [
		'while %I%',
		'endwhile',
	],
	'con;': [
		'const %I%: %P% =',
	],
	'var;': [
		'var %I%: %P% =',
	],
}


# sh {{{1

ABBREVIATION['sh'] = {
	'lcl;': 'local',
}

TEXT_BLOCK['sh'] = {
	'jj;': [
		'#! \\/usr\\/bin\\/bash',
		'',
		'',
		'main() {',
		'%S%%I%#BODY',
		'}',
		'',
		'main \"$@\"',
		'',
	],
	'if;': [
		'if %I%; then',
		'#elif ; then',
		'#else',
		'fi',
	],
	'for;': [
		'for %I% in %P%; do',
		'done',
	],
	'sw;': [
		'case %I% in',
		'%S%#%P%)',
		'%S%#;;',
		'%S%#*)',
		'%S%#;;',
		'esac',
	],
	'whl;': [
		'while %I%; do',
		'done',
	],
}


# gdscript {{{1

TEXT_BLOCK['gdscript'] = {
	'fu;': [
		'func %I%() -> void:',
	],
	'fuu;': [
		'static func %I%() -> void:',
	],
	'if;': [
		'if %I%:',
		'#elif:',
		'#else:',
	],
	'for;': [
		'for i: %P% in %I%:',
	],
	'whl;': [
		'while %I%:',
	],
	'con;': [
		'const %I%: %P% =',
	],
	'var;': [
		'var %I%: %P% =',
	],
}


# golang {{{1

TEXT_BLOCK['go'] = {
	'jj;': [
		'package %I%main',
		'',
		'import (',
		')',
		'',
		'func main() {',
		'}',
	],
	'if;': [
		'if %I% {',
		'} else if {',
		'} else {',
		'}',
	],
	'sw;': [
		'switch %I% {',
		'case :',
		'default:',
		'}',
	],
	'for;': [
		'for %I% {',
		'}',
	],
	'con;': [
		'const %I% =',
	],
	'var;': [
		'var %I% =',
	],
}

