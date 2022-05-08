" viと非互換のvimの独自拡張機能を使用
set nocompatible
set encoding=utf-8
set fileencodings=utf-8,iso-2202-jp,sjis,euc-jp
set fileformats=unix,dos
" バックアップをとらない
set nobackup
set history=50
" 検索時に大文字小文字を区別しない
set ignorecase
" 検索語に大文字を混ぜる場合には大文字小文字を区別する
set smartcase
" 言語に併せてインデントを自動挿入
set smartindent
set number
" 改行やタブを可視化
set list
set showmatch
" set autoindent
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

" 括弧補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
" pythonの場所を明示
let g:python_host_prog = '/home/yosaka/.pyenv/versions/2.7.17/envs/vim2/bin/python'
let g:python3_host_prog = '/home/yosaka/.pyenv/versions/3.8.2/envs/vim/bin/python'

call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'ambv/black'
Plug 'dense-analysis/ale'
call plug#end()

" nerdtree settings
nmap <C-b> :NERDTreeToggle<CR>
let g:airline#extentions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" formatter settings
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', "trim_whitespace"],
\    'python': ['black'],
\    'cpp': ['clang-format'],
\    'c': ['clang-format'],
\}
let g:ale_python_autopep8_options = '--max-line-length=99'
let g:ale_python_flake8_option = '--max-line-length=99'
let g:ale_fix_on_save = 1

" Ctr-h: move left tab, Ctrl-l move right tab
nnoremap <C-h> gT
nnoremap <C-l> gt
" terminal mode setting
tnoremap <C-n> <C-\><C-n>

" Airline settings
let g:airline_powerline_fonts = 1

" Esc Setting
inoremap jk <Esc>
inoremap jj <Esc>

" /// Enable Netrw (default file browser)
filetype plugin on
" /// Netrw SETTINGS
" let g:netwr_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_winsize = 30
" let g:netrw_sizestyle = "H"
" let g:netrw_timefmt = "%Y/%m/%d(%a) %H:%M:%S"
" let g:netrw_preview = 1
"/// SPLIT BORDER SETTINGS
hi VertSplit cterm=none
" Tabで補完が効くように設定
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
""" <Tab>で次、<S+Tab>で前
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>":
" 言語ごとのタブ設定
autocmd FileType cpp set shiftwidth=2 softtabstop=2
