# My Vim 9 Setting Files

## Introduction

[Watch demo on Y2B](https://youtu.be/96Z_4cCv7Is).

This repository stores all my Vim 9 setting files except a third party colorsheme ([Solarized 8](https://github.com/lifepillar/vim-solarized8)) and a tiny bit of private data. It works both in terminal and GUI environment.

If you have a clean environment, that is, an empty `$HOME/.vim/` folder and no `$HOME/.vimrc` file, download all the files and put them into `$HOME/.vim/`. When you start (g)Vim, it should look almost the same as the demo above, except that the colorscheme is `desert`.

Actually, my Vim launches in two steps. First, there is a `$HOME/.vimrc` that defines `packpath`, `runtimepath` and a few private data (see Appendix, below). Then, at the end of `$HOME/.vimrc`, it sources the `vimrc` in this repository. What's the benefit?

1. I can put personal scripts anywhere.
2. I can exclude third party plugins and my private data from the public repository.

## Folder Structure

If something in the demo catches your eye, search a key map (`plugin/key_map.vim`) or command (`plugin/quick_command.vim`), or a file specific feature (`ftplugin/*.vim`). Although `autoload/*.vim` scripts do the most hard work, it might not be a good start point for an outlander new to Vvardenfell. 

Besides, key maps call functions directly without a middle layer (`<plug>`). It's not the best practice for a plugin, but quite convenient for personal use.

## Appendix

```
" sample .vimrc
" NOTE: DO NOT use Vim 9 syntax. It seems that filetypes cannot be handled
" properly.


set nocompatible

let g:PRIVATE_DATA = {}
lockvar! g:PRIVATE_DATA

if has('win32')
    set packpath+=pack\path
    set runtimepath+=runtime\path
    cd working\dir
    source path\to\vimrc
else
    set packpath+=pack/path
    set runtimepath+=runtime/path
    cd working/dir
    source path/to/vimrc
endif
```

