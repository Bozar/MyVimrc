vim9script

export const ABBREVIATION: dict<any> = {
	'vv;': 'var',
	'vc;': 'const',
	'vl;': '[]<esc>h',
	'vm;': 'map[]%P%<esc>hF[',
	'vf;': 'func () (%P%)<esc>h2F(',
	'kt;': 'true<esc>h',
	'kf;': 'false<esc>h',
	'ky;': 'type',
	'kd;': 'defer',
	'ks;': 'string<esc>h',
	'ku;': 'rune<esc>h',
	'ke;': 'err != nil<esc>h',
	'kr;': 'return<esc>h',
	'kc;': 'continue<esc>h',
	'kb;': 'break<esc>h',
}

export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'package%I% ',
		'',
		'import (',
		'%P%',
		')',
	],
	'if;': [
		'if %I% {',
		'%FS%%FS%} else if {',
		'%FS%%FS%} else {',
		'}',
	],
	'for;': [
		'for %I%; %P%; %P% {',
		'}',
	],
	'frr;': [
		'for %I%, %P% := range %P% {',
		'}',
	],
	'sw;': [
		'switch %I% {',
		'case %P%:',
		'case :',
		'case :',
		'case :',
		'case :',
		'default:',
		'}',
	],
	'fu;': [
		'func %I%(%P%) (%P%) {',
		'}',
	],
	'fum;': [
		'func (%I% *%P%) %P%(%P%) (%P%) {',
		'}',
	],
	'fut;': [
		'func Test%I%(t *testing.T) {',
		'}',
	],
	'vs;': [
		'struct %I%{',
		'}',
	],
	'vi;': [
		'interface %I%{',
		'}',
	],
}
