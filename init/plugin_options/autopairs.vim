lua << EOF
require("nvim-autopairs").setup {}
-- require('gitsigns').setup()
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

EOF
