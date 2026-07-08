vim9script

export const ABBREVIATION: dict<any> = {
	'vv;': 'var',
	'cc;': 'const',
	'sl;': '[]<esc>h',
	'mm;': 'map[]%P%<esc>hF[',
	'fuy;': 'func () (%P%)<esc>h2F(',
	'tt;': 'true<esc>h',
	'ff;': 'false<esc>h',
	'yy;': 'type',
	'df;': 'defer',
	'ss;': 'string<esc>h',
	'rr;': 'rune<esc>h',
	'ee;': 'err != nil<esc>h',
	'rt;': 'return<esc>h',
	'ct;': 'continue<esc>h',
	'bk;': 'break<esc>h',
	'cmp;': 'comparable',
}

export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'package %I%%P%',
		'',
		'import (',
		'%P%',
		')',
	],
	'if;': [
		'if %I%%P% {',
		'%FS%%FS%} else if {',
		'%FS%%FS%} else {',
		'}',
	],
	'for;': [
		'for %I%%P%; %P%; %P% {',
		'}',
	],
	'frr;': [
		'for %I%%P% := range %P% {',
		'}',
	],
	'sw;': [
		'switch %I%%P% {',
		'case %P%:',
		'case :',
		'case :',
		'case :',
		'case :',
		'default:',
		'}',
	],
	'fu;': [
		'func %I%%P%(%P%) (%P%) {',
		'}',
	],
	'fum;': [
		'func (%I%%P% *%P%) %P%(%P%) (%P%) {',
		'}',
	],
	'fut;': [
		'func Test%I%%P%(t *testing.T) {',
		'}',
	],
	'st;': [
		'struct %I%%P%{',
		'}',
	],
	'it;': [
		'interface %I%%P%{',
		'}',
	],
}
