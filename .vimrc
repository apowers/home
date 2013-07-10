set number "show line numbers
set nocompatible "Use Vim settings, not vi-compatible
set backspace=indent,eol,start "allow backspacing over everything in insert mode
set autoread "update file if it has change on disk

" spaces for indenting and tab stops
set shiftwidth=2
set tabstop=2
set expandtab "Spaces instead of tabs

" Always  set auto indenting on
set autoindent
set si "Smart indent

" select when using the mouse
set selectmode=mouse

" set the commandheight
set cmdheight=2

" do not keep a backup files
set nobackup
set nowritebackup

" keep 50 lines of command line history
set history=50

" show the cursor position all the time
set ruler

" show (partial) commands
set showcmd

" do incremental searches (annoying but handy);
set incsearch

" Set ignorecase on
set ignorecase

" smart search (override 'ic' when pattern has uppers)
set scs

" Set status line
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable filetype plugins
if has('gui_running')
  filetype plugin on
  filetype indent on
" Enable syntax highlighting
  syntax enable
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always display a status line at the bottom of the window
set laststatus=2

" showmatch: Show the matching bracket for the last ')'?
set showmatch

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")

  syntax on
  set hlsearch
endif

