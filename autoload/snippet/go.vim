vim9script


export const ABBREVIATION: dict<any> = {
	'fut;': 'func()',
}


export const TEXT_BLOCK: dict<any> = {
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
	'vc;': [
		'const %I% =',
	],
	'vv;': [
		'var %I% =',
	],
	'fu;': [
		'func %I%() {',
		'}',
	],
	'fuu;': [
		'func (%I%) () {',
		'}',
	],
}

