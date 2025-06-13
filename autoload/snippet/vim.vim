vim9script


export const ABBREVIATION: dict<any> = {
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


export const TEXT_BLOCK: dict<any> = {
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

