vim9script


export const ABBREVIATION: dict<any> = {}


export const TEXT_BLOCK: dict<any> = {
	'vv;': [
		'local %I%'
	],
	'vc;': [
		'readonly %I%'
	],
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
	'wh;': [
		'while %I%; do',
		'done',
	],
}

