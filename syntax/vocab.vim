vim9script

syntax case ignore

syntax match column1 /\v\C^[^\t]+\t/

highlight link column1 Statement
