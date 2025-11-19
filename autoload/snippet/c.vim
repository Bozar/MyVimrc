vim9script


export const ABBREVIATION: dict<any> = {
	'vc;': 'const',
	'vd;': '#define',
	'va;': 'static',
	'vu;': 'struct',
}


export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'#include <stdio.h>',
		'#include <stdlib.h>',
		'#include <stdbool.h>',
		'',
		'\\/\\/#include \\\"%I%.h\\\"',
		'',
		'',
	],
	'fu;': [
		'static %P% %I%(%P%);',
	],
	'if;': [
		'if (%I%) {',
		'\\/\\/} else if () {',
		'\\/\\/} else {',
		'}',
	],
	'sw;': [
		'switch (%I%) {',
		'%S%case %P%:',
		'%S%%S%break;',
		'%S%default:',
		'%S%%S%break;',
		'}',
	],
	'for;': [
		'for (%I%; %P%; %P%) {',
		'}',
	],
	'wh;': [
		'while (%I%) {',
		'}',
	],
	'dow;': [
		'do {',
		'%S%%P%',
		'} while (%I%);',
	],
	'iff;': [
		'%<%#if %I%',
		'%<%\\/\\/#elif',
		'%<%\\/\\/#else',
		'%<%#endif',
	],
}
