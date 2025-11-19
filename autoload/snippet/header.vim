vim9script


export const ABBREVIATION: dict<any> = {
	'vc;': 'const',
	'vd;': '#define',
	'va;': 'static',
	'vu;': 'struct',
}


export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'#ifndef %I%_H',
		'#define %P%',
		'',
		'',
		'#include <stdbool.h>',
		'',
		'',
		'#endif',
	],
	'fu;': [
		'%P% %I%(%P%);',
	],
	'if;': [
		'%<%#if %I%',
		'%<%\\/\\/#elif',
		'%<%\\/\\/#else',
		'#%<%endif',
	],
}
