vim9script

export const ABBREVIATION: dict<any> = {
	'vv;': 'local',
	'vc;': 'readonly',
	'kr;': 'return<esc>h',
	'kc;': 'continue<esc>h',
	'kb;': 'break<esc>h',
	'kd;': '# shellcheck disable=SC<esc>h',
}

export const TEXT_BLOCK: dict<any> = {
	'jj;': [
		'#! %FS%usr%FS%bin%FS%bash',
		'%I%',
		'',
		'main() {',
		'}',
		'',
		'main \"$@\"',
	],
	'fu;': [
		'%P%() {',
		'}',
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
		'%S%%P%)',
		'%S%;;',
		'%S%#*)',
		'%S%#;;',
		'esac',
	],
	'wh;': [
		'while %I%; do',
		'done',
	],
}
