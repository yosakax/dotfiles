" viと非互換のvimの独自拡張機能を使用
set nocompatible
set encoding=utf-8
set fileencodings=utf-8,iso-2202-jp,sjis,euc-jp
set fileformats=unix,dos
" バックアップをとらない
set nobackup
set noswapfile
set history=50
" 検索時に大文字小文字を区別しない
" set ignorecase
" 検索語に大文字を混ぜる場合には大文字小文字を区別する
set smartcase
" 言語に併せてインデントを自動挿入
set smartindent
set number
" 改行やタブを可視化
set listchars=eol:⏎,tab:>-,trail:·,extends:>,precedes:<
set list
set showmatch
set clipboard+=unnamedplus
set autoindent
" 構文ごとに色分け
syntax on
highlight Comment ctermfg=LightCyan
" 折り返し
set wrap
set expandtab
set tabstop=4
set shiftwidth=4
" マウスを有効に
set mouse=a

" カーソル位置強調
" set cursorline
" set cursorcolumn

" 括弧補完
" inoremap { {}<LEFT>
" inoremap [ []<LEFT>
" inoremap ( ()<LEFT>
" inoremap " ""<LEFT>
" inoremap ' ''<LEFT>
" inoremap { {}<Left>
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" " inoremap ( ()<ESC>i
" inoremap (<Enter> ()<Left><CR><ESC><S-o>
" pythonの場所を明示
let g:python_host_prog = expand('$HOME/.pyenv/versions/3.11.4/envs/vim/bin/python')
let g:python3_host_prog = expand('$HOME/.pyenv/versions/3.11.4/envs/vim/bin/python')

" /// Netrw SETTINGS
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 30
let g:netrw_sizestyle = 'H'
let g:netrw_timefmt = '%Y/%m/%d(%a) %H:%M:%S'
let g:netrw_preview = 1
"/// SPLIT BORDER SETTINGS
hi VertSplit cterm=none
" Ctr-h: move left tab, Ctrl-l move right tab
set signcolumn=yes

let g:loaded_netrw=1
let g:netrw_loaded_netrwPlugin=1
