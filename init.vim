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

" カーソル位置強調
set cursorline
set cursorcolumn

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
let g:python_host_prog = expand('$HOME/.pyenv/versions/2.7.17/envs/vim2/bin/python')
let g:python3_host_prog = expand('$HOME/.pyenv/versions/3.8.2/envs/vim/bin/python')
let g:vscode = 1

call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'ambv/black'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Plug 'zah/nim.vim'
Plug 'prabirshrestha/async.vim'
Plug 'tpope/vim-fugitive'
Plug 'rust-lang/rust.vim'
Plug 'cocopon/iceberg.vim'
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'tomasr/molokai'
Plug 'rebelot/kanagawa.nvim', {'commit': 'fc2e308'}
call plug#end()

let g:fern#renderer = "nerdfont"


let g:coc_global_extensions = [
\ 'coc-rust-analyzer',
\ 'coc-pairs',
\ 'coc-pyright'
\ ]

" colorscheme molokai
colorscheme kanagawa
set pumblend=20
set termguicolors
" 背景透過
" highlight Normal ctermbg=NONE guibg=NONE
" highlight NonText ctermbg=NONE guibg=NONE
" highlight LineNr ctermbg=NONE guibg=NONE
" highlight Folded ctermbg=NONE guibg=NONE
" highlight EndOfBuffer ctermbg=NONE guibg=NONE



" set update time for git plugin
set updatetime=100

" Fern settings
nmap <C-b> :Fern . -reveal=% -drawer -toggle -width=30<CR>
let g:airline#extentions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
nmap <C-p> :Files<CR>

" formatter settings
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', "trim_whitespace"],
\    'python': ['black','isort'],
\    'cpp': ['clang-format'],
\    'c': ['clang-format'],
\}
let g:ale_python_autopep8_options = '--max-line-length=99'
let g:ale_python_flake8_option = '--max-line-length=99'
let g:ale_fix_on_save = 1

" Ctr-h: move left tab, Ctrl-l move right tab
set signcolumn=yes
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap j gj
nnoremap k gk
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
" let g:netrw_sizestyle = 'H'
" let g:netrw_timefmt = '%Y/%m/%d(%a) %H:%M:%S'
" let g:netrw_preview = 1
"/// SPLIT BORDER SETTINGS
hi VertSplit cterm=none
" Tabで補完が効くように設定
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"
inoremap <silent><expr> <C-h> coc#pum#visible() ? coc#pum#cancel() : "\<C-h>"

" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm(): "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>" " " "\<C-h>"
inoremap <silent><expr> <C-space> coc#refresh()



""" markdown settings
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" for path with space
" valid: `/path/with\ space/xxx`
" invalid: `/path/with\\ space/xxx`
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or empty for random
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
" let g:mkdp_theme = 'dark'
let g:mkdp_theme = 'light'

" nimlang setting
" if executable('nimlsp')
"     autocmd Users lsp_setup call lsp#register_server({
"                 \ 'name': 'nimlsp',
"                 \ 'cmd': {server_info->[&shell, &shellcmdflag, 'nimlsp ~/.nimble/bin/nim']},
"                 \ 'whitelist': ['nim'],
"                 \})
"     autocmd FileType nim call <SID>configure_lsp()
" endif

" rust自動フォーマット
let g:rustfmt_autosave = 1

" 言語ごとのタブ設定
if has("autocmd")
    filetype plugin on
    filetype indent on
    autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType c setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType js setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    " autocmd FileType cpp setlocal commentstring=//\ %s
    " autocmd FileType c setlocal commentstring=//\ %s
endif
