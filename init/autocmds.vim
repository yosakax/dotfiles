" 言語ごとのタブ設定
if has("autocmd")
    " filetype plugin on
    " filetype indent on
    autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType c setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType javascriptreact setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd FileType typescriptreact setlocal shiftwidth=2 softtabstop=2 commentstring=//\ %s
    autocmd TermOpen *  setlocal nonumber
endif

augroup ReactFiletypes
  autocmd!
  autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
  autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
augroup END
