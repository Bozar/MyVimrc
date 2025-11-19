vim9script


export const ABBREVIATION: dict<any> = {}


export const TEXT_BLOCK: dict<any> = {
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
	'wh;': [
		'while %I%:',
	],
	'vc;': [
		'const %I%: %P% =',
	],
	'vv;': [
		'var %I%: %P% =',
	],
}

