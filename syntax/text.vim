vim9script


syntax case ignore

syntax match textTitle /\v^.{-}\s\{{3}\d?$/
syntax match textTitle /\v^`{3,}$/
syntax match textList /\v^\s*\*\s/

highlight link textTitle Title
highlight link textList Title

