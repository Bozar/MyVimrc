vim9script


export const ABBREVIATION: dict<any> = {
}


export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'#import %I%',
		'',
		'',
	],
	'fu;': [
		'def %I%(%P%):',
	],
	'if;': [
		'if %I%:',
		'#elif:',
		'#else:',
	],
	'for;': [
		'for %I% in %P%:',
		'#else:',
	],
	'wh;': [
		'while %I%:',
		'#else:',
	],
	'vl;': [
		'class %I%:',
		'%S%def __init__(self):',
	],
	'sw;': [
		'match %I%',
		'%S%case %P%:',
		'%S%#case _:',
	],
	'try;': [
		'try:',
		'except %I%:',
		'#else:',
		'#finally:',
	],
}
