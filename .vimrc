" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add relative numbers to each line on the left-hand side.
set number relativenumber

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Ignore capital letters during search.
set ignorecase

" Set the commands to save in history default number is 20.
set history=1000

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Use highlighting when doing a search.
set hlsearch

" Show matching words during a search.
set showmatch

" Show partial command you type in the last line of the screen.
set showcmd

" Keybinding
nnoremap <silent> <esc> :noh<cr><esc>
