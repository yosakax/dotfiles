local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

-- Normal mode --
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- ESC*2 でハイライトやめる
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)


-- Insert mode --
keymap("i", "jk", "<ESC>", opts)
keymap("i", "jj", "<ESC>", opts)

-- coc keymap
keymap("i", "<silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1)", "\<C-j>", opts)
keymap("i", "<silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1)", "\<C-k>")
-- inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
keymap("i", "<silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel()", "\<Esc>", opts)
keymap("i", "<silent><expr> <C-h> coc#pum#visible() ? coc#pum#cancel()", "\<C-h>", opts)

-- inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
keymap("i", "<silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()", "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>", opts)

keymap("i", "<silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1)", "\<S-TAB>" " " "\<C-h>", opts)
keymap("i", "<silent><expr> <C-space>", "coc#refresh()", opts)


