local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- remove whitespace on save
autocmd("BufWritePre", {
	pattern = "*",
	command = ":%s/\\s\\+$//e",
})

-- dont auto commenting new lines
autocmd("BufEnter", {
	pattern = "*",
	command = "set fo-=c fo-=r fo-=o",
})

-- restore cursor location when file is opened
autocmd({"BufReadPost"}, {
	pattern = {"*"},
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})
