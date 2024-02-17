
" Fern settings
nmap <C-b> :Fern . -reveal=% -drawer -toggle -width=30<CR>
" let g:airline#extentions#tabline#enabled = 1
" let g:airline#extentions#tabline#enabled = 1
nmap <C-p> :Files<CR>
" nnoremap <C-h> gT
" nnoremap <C-l> gt
nnoremap <silent> <C-h> :BufferMovePrevious<CR>
nnoremap <silent> <C-l> :BufferMoveNext<CR>
nnoremap j gj
nnoremap k gk
" terminal mode setting
tnoremap <C-n> <C-\><C-n>



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
nmap <silent> <C-]> <Plug>(coc-definition)
" nmap <silent> <C-]> <Plug>(coc-implementation)
" nmap <silent><C-t> :noh<CR><C-o>
"
" buffer keybinds
nnoremap <silent> <A-c> <Cmd>BufferClose<CR>
nnoremap <silent> <C-j> <Cmd>BufferPrevious<CR>
nnoremap <silent> <C-k> <Cmd>BufferNext<CR>
nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>
