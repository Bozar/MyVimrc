vim9script


set nocompatible

const IS_GUI: bool = has('gui_running')
const IS_WINDOWS: bool = has('win32') || has('win32unix')

# https://github.com/lifepillar/vim-solarized8
# Refer to the readme for `g:solarized_?` settings.
const COLOR_SCHEME: string = 'solarized8'


if !IS_GUI
	set termguicolors
endif
# https://vi.stackexchange.com/questions/18932/
try
	execute 'colorscheme ' .. COLOR_SCHEME
	if COLOR_SCHEME ==# 'solarized8'
		# No italics.
		g:solarized_italics = 0
		# Use red cursor if possible. Does not work in terminal. :(
		g:solarized_old_cursor_style = 0
		# Enable more syntax highlighting groups.
		g:solarized_extra_hi_groups = 1
	endif
	set background=light
catch /^Vim\%((\a\+)\)\=:E185/
	colorscheme desert
	set background=dark
endtry


# UI language: change the name of 'lang' folder will force Vim to use English.

filetype plugin indent on
syntax enable
set backspace=indent,eol,start
set autoread


# Do not insert 2 spaces after punctuations when joining lines.
set nojoinspaces
# Allow hiding modified buffers.
set hidden
# Do not beep.
set belloff=all
set statusline=%!g:MyStatusLine(0)
set tabline=%!g:MyTabLine()
set showtabline=2


set number
set linebreak
# Do not break at `Tab`s.
set breakat=\ !@*-+;:,./?
set display=lastline
set laststatus=2
set ambiwidth=double
set linespace=0
set list
# https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
# <c-k>>>
set listchars=tab:»\ ,
#set listchars=tab:[\ ,
# BUG?: A long line containing tabs in a narrow window cannot be shown properly,
# if a tab is shown as three characters.
#set listchars=tab:].[,
#set listchars=tab:].[,lead:›
set cursorline


set wildmode=full
set wildmenu
set cmdheight=2
set cmdwinheight=10
set history=998
set showcmd


set tabstop=8
set softtabstop=0
set shiftwidth=0
set noexpandtab
set autoindent
set shiftround


set ignorecase
set incsearch
set smartcase


# Overwrite fold methods in filetype plugins.
set foldmethod=marker
# Unfold all text by default.
set foldlevel=99


set fileformat=unix
set fileformats=unix,dos
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1
# Case-insensitive file names
set fileignorecase


# Use both * and + registers when yanking in visual mode. Show the least GUI
# components.
set guioptions=aPc
#set guioptions=!aPc
# Do not blink cursor in all modes.
set guicursor+=a:blinkon0


set notimeout
set noesckeys
g:mapleader = ' '


set matchpairs+=<:>
set matchpairs+=《:》
set matchpairs+=“:”
set matchpairs+=‘:’
set matchpairs+=（:）


# Font
if IS_WINDOWS
	set renderoptions=type:directx
	set guifont=Consolas:h18:cANSI:qDRAFT
	#set guifont=Fira_Code_Medium:h16:W500:cANSI:qDRAFT
	set guifontwide=kaiti:h20:cGB2312:qDRAFT
else
	set guifont=DejaVu\ Sans\ \Mono\ 14
endif


# Netrw
# Tree style listing
g:netrw_liststyle = 3
# Hide banner
g:netrw_banner = 0


# QuickFix
g:qf_disable_statusline = 1

