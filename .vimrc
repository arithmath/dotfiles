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
" NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'bling/vim-airline'

" Unite
NeoBundle 'Shougo/unite.vim'

" ref
NeoBundle 'thinca/vim-ref'

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

noremap <Space>n : bn!<CR>
noremap <Space>p : bp!<CR>
noremap <Space>q : bw<CR>

"let g:miniBufExplMapWindowNavVim=1
"let g:miniBufExplSplitBelow=0
"let g:miniBufExplMapWindowNavArrows=1
"let g:miniBufExplMapCTabSwitchBufs=1
"let g:miniBufExplModSelTarget=1
"let g:miniBufExplSplitToEdge=1
"let g:miniBufExplMaxSize=10

" airlineの設定
let g:airline#extensions#tabline#enabled = 1

" Uniteの設定
let g:unite_enable_start_insert=1
nnoremap <silent> <Space>uy :<C-u>Unite history/yank<CR>
nnoremap <silent> <Space>ub :<C-u>Unite buffer<CR>
nnoremap <silent> <Space>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Space>ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <Space>uu :<C-u>Unite file_mru buffer<CR>

" ウィンドウサイズの変更
nnoremap <silent> <Space>j 5<C-w>+
nnoremap <silent> <Space>k 5<C-w>-
nnoremap <silent> <Space>h 10<C-w><
nnoremap <silent> <Space>l 10<C-w>>

" ウィンドウ分割
nnoremap <silent> <Space>s :<C-u>split<CR>
nnoremap <silent> <Space>v :<C-u>vsplit<CR>

" refの設定
let g:ref_phpmanual_path = $PHP_MANUAL
