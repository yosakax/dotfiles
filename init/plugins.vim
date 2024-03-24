call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'alaviss/nim.nvim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
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
Plug 'rebelot/kanagawa.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'vim-scripts/taglist.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'sainnhe/everforest'
" Plug 'dinhhuy258/git.nvim'
" Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'majutsushi/tagbar'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-surround'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'mhinz/vim-startify'
Plug 'TaDaa/vimade'

" Plug 'puremourning/vimspector'
call plug#end()

let g:coc_global_extensions = [
\ 'coc-rust-analyzer',
\ 'coc-clangd',
\ 'coc-pyright',
\ 'coc-prettier',
\ 'coc-tsserver',
\ 'coc-eslint',
\ 'coc-css'
\ ]

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


runtime init/plugin_options/ibl.vim
runtime init/plugin_options/autopairs.vim
runtime init/plugin_options/vimspector.vim
runtime init/plugin_options/barbar.vim
runtime init/plugin_options/airline.vim
runtime init/plugin_options/langs.vim
