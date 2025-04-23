vim9script


syntax case ignore

syntax match locLabel /\v\C-(\a|\d)+$/
syntax match locLabel /\v\C\t#MARK#\t/
syntax match locLabel /\v\C#END#$/
syntax match locLabel /\v\C#CR#/
syntax match locSource /\v\C^[^\t]+\t/
syntax match locSource /\v\C^"[^\t]+$/
syntax match locTitle /\v^.{-}\s\{{3}\d?$/

highlight link locSource Statement
highlight link locLabel Identifier
highlight link locTitle Comment

