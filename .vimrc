set nocompatible
set number
set completeopt+=menuone
set completeopt+=noinsert
set shortmess+=c
set belloff+=ctrlg

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
Plug 'arzg/vim-colors-xcode'
call plug#end()
