set autoindent
"set expandtab
set number
set showmatch
set tabstop=4
syntax on
"colorscheme zenburn
"colorscheme pyte
colorscheme desert

"不過視文字列を表示する
set list
set listchars=tab:/_,trail:_,eol:↲,extends:»,precedes:«,nbsp:.

"タブに色づけ
highlight TabString ctermbg=gray guibg=gray
au BufWinEnter * let w:m2 = matchadd("TabString", '\t')
au WinEnter * let w:m2 = matchadd("TabString", '\t')
