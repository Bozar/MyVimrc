vim9script


export def InsertCodeBlock(map_mode: number): void
    # Normal mode
    if map_mode ==# 0
        execute ':s/$/\r````\r\r````/'
        execute ':normal! k'
    # Visual mode
    elseif map_mode ==# 1
        execute ":'>" .. 's/$/\r````/'
        execute ":'<" .. 's/^/````\r/'
    endif
enddef

