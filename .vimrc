set autoindent
set expandtab
set number
set showmatch
set tabstop=4
set hlsearch    " 検索語を強調表示 
set incsearch   " インクリメンタルサーチ(1語入力するたびに検索)
syntax on
colorscheme modified_zenburn
"colorscheme pyte
"colorscheme desert

"不過視文字列を表示する
set list
set listchars=tab:/_,trail:_,eol:↲,extends:»,precedes:«,nbsp:.

" -------------------------------------------
" NeoBundleの設定
" ※ https://github.com/Shougo/neobundle.vim

set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

" vim上で編集中のプログラムを実行する
NeoBundle 'git://github.com/thinca/vim-quickrun.git'

" minibufexpl
NeoBundle 'fholgado/minibufexpl.vim'

filetype on

"
" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

" NeoBundleの設定ここまで
" -------------------------------------------


let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplSplitBelow=0
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize=10
