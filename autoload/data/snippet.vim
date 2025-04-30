vim9script


export final ABBREVIATION: dict<any> = {}
export final TEXT_BLOCK: dict<any> = {}

export const INSERT_PLACEHOLDER: string = '%I%'
export const SPACE_PLACEHOLDER: string = '%S%'
export const DEFAULT_PLACEHOLDER: string = '%P%'

export const PATTERN_INSERT_PLACEHOLDER: string = '\V\C' .. INSERT_PLACEHOLDER
export const PATTERN_SPACE_PLACEHOLDER: string = '\V\C' .. SPACE_PLACEHOLDER
export const PATTERN_DEFAULT_PLACEHOLDER: string = '\V\C' .. DEFAULT_PLACEHOLDER


ABBREVIATION['vim'] = {
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

TEXT_BLOCK['vim'] = {
    'vm;': [
        'vim9script',
        '',
        "#import auto '%I%' as",
        '',
        '',
    ],
    'edf;': [
        'export def %I%(): void',
        '%S%#BODY',
        'enddef',
    ],
    'df;': [
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

