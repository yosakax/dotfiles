-- base settings

-- viと非互換のvimの独自拡張機能を使用
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "iso-2202-jp", "sjis", "euc-jp" }
vim.opt.fileformats = { "unix", "dos" }
vim.g.python_host_prog = "$HOME/.config/nvim/nvim-python/.venv/bin/python"
vim.g.python3_host_prog = "$HOME/.config/nvim/nvim-python/.venv/bin/python"
-- バックアップをとらない
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.history = 50
-- 検索時に大文字小文字を区別しない
vim.opt.ignorecase = true
-- 検索語に大文字を混ぜる場合には大文字小文字を区別する
vim.opt.smartcase = false
-- 言語に併せてインデントを自動挿入
vim.opt.smartindent = true
vim.opt.number = true
-- 改行やタブを可視化
vim.opt.listchars = { eol = "⏎", tab = ">-", trail = "·", extends = ">", precedes = "<" }
vim.opt.list = true
vim.opt.showmatch = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.autoindent = true
-- 構文ごとに色分け
vim.cmd("syntax on")
vim.cmd("highlight Comment ctermfg=LightCyan")
-- 折り返し
vim.opt.wrap = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- マウスを有効に
vim.opt.mouse = "a"
vim.opt.laststatus = 3

-- spell check
-- vim.opt.spell = true

-- カーソル位置強調
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- plugins below -------------------------------------------------------------------------------------------
		{
			"tpope/vim-commentary",
		},
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"folke/tokyonight.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				-- vim.cmd([[colorscheme tokyonight]])
			end,
		},
		{
			"rebelot/kanagawa.nvim",
			lazy = false,
			priotiry = 1000,
			config = function()
				vim.cmd([[colorscheme kanagawa]])
			end,
		},
		-- I have a separate config.mappings file where I require which-key.
		-- With lazy the plugin will be automatically loaded when it is required somewhere
		{ "folke/which-key.nvim", lazy = true },

		{
			"nvim-neorg/neorg",
			-- lazy-load on filetype
			ft = "norg",
			-- options for neorg. This will automatically call `require("neorg").setup(opts)`
			opts = {
				load = {
					["core.defaults"] = {},
				},
			},
		},

		{
			"dstein64/vim-startuptime",
			-- lazy-load on a command
			cmd = "StartupTime",
			-- init is called during startup. Configuration for vim plugins typically should be set in an init function
			init = function()
				vim.g.startuptime_tries = 10
			end,
		},

		{
			"hrsh7th/nvim-cmp",
			-- load cmp on InsertEnter
			event = "InsertEnter",
			-- these dependencies will only be loaded when cmp loads
			-- dependencies are always lazy-loaded unless specified otherwise
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
			},
			config = function() end,
		},

		-- if some code requires a module from an unloaded plugin, it will be automatically loaded.
		-- So for api plugins like devicons, we can always set lazy=true
		{ "nvim-tree/nvim-web-devicons", lazy = true },

		-- you can use the VeryLazy event for things that can
		-- load later and are not important for the initial UI
		{ "stevearc/dressing.nvim", event = "VeryLazy" },

		{
			"Wansmer/treesj",
			keys = {
				{ "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
			},
			opts = { use_default_keymaps = false, max_join_length = 150 },
		},

		{
			"monaqa/dial.nvim",
			-- lazy-load on keys
			-- mode is `n` by default. For more advanced options, check the section on key mappings
			keys = { "<C-a>", { "<C-x>", mode = "n" } },
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		-- local plugins need to be explicitly configured with dir
		{ dir = "~/projects/secret.nvim" },

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {
				-- add any options here
			},
			dependencies = {
				-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
				"MunifTanjim/nui.nvim",
				-- OPTIONAL:
				--   `nvim-notify` is only needed, if you want to use the notification view.
				--   If not available, we use `mini` as the fallback
				"rcarriga/nvim-notify",
			},
		},
		{
			"neovim/nvim-lspconfig",
			-- opts = {
			-- 	setup = {
			-- 		rust_analyzer = function()
			-- 			return true
			-- 		end,
			-- 	},
			-- },
		},
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "L3MON4D3/LuaSnip" },

		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "MunifTanjim/prettier.nvim" },
		{ "rust-lang/rust.vim" },
		-- {
		-- 	"mrcjkb/rustaceanvim",
		-- 	version = "^5", -- Recommended
		-- 	lazy = false, -- This plugin is already lazy
		-- },
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					signs = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
						untracked = { text = "┆" },
					},
					signs_staged = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
						untracked = { text = "┆" },
					},
				})
			end,
		},
		{
			"romgrk/barbar.nvim",
			dependencies = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
			init = function()
				vim.g.barbar_auto_setup = true
			end,
			opts = {
				-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
				animation = true,
				insert_at_start = true,
				-- …etc.
			},
			version = "^1.0.0", -- optional: only update when a new 1.x version is released
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
			-- use opts = {} for passing setup options
			-- this is equalent to setup({}) function
		},
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		},
		{ "lambdalisue/fern.vim", lazy = false },
		{ "lambdalisue/fern-git-status.vim" },
		{ "lambdalisue/nerdfont.vim" },
		-- {
		-- 	"lambdalisue/fern-renderer-nerdfont.vim",
		-- 	lazy = false,
		-- 	config = function()
		-- 		vim.g["fern#renderer"] = "nerdfont"
		-- 		vim.g["fern#renderers"] = { "nerdfont" }
		-- 	end,
		-- },
		{ "lambdalisue/fern-hijack.vim", lazy = false },
		{ "lambdalisue/vim-glyph-palette" },

		-- plugins above -------------------------------------------------------------------------------------------
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "tokyonight" } },
	install = { colorscheme = { "kanagawa" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- LSPサーバアタッチ時の処理
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ctx)
		-- enable inlay-hint
		vim.lsp.inlay_hint.enable()
		local set = vim.keymap.set
		set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
		set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
		set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
		set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
		-- set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
		set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
		set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
		set(
			"n",
			"<space>wl",
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
			{ buffer = true }
		)
		set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
		set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
		set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
		set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
		set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = true })
		set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
		set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
		set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
		set("n", "<C-f>", "<cmd>lua vim.lsp.buf.format()<CR>", { buffer = true })
		set("n", "<C-n>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
	end,
})

require("lualine").setup()

-- プラグインの設定
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
	-- function(server_name)
	-- 	require("lspconfig")[server_name].setup({})
	-- end,
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
})

-- lspのハンドラーに設定
capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { focusable = true })

-- lspの設定後に追加
vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<S-tab>"] = cmp.mapping.select_prev_item(),
		["<tab>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Enter>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

-- barbar.nvim keybinds
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "<C-j>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<C-k>", "<Cmd>BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<C-h>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<C-l>", "<Cmd>BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
-- Sort automatically by...
map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", opts)
map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- nvim-autopairsの設定
local npairs = require("nvim-autopairs")
npairs.setup({
	check_ts = true,
})

require("gitsigns").setup()

-- cmpとautopairsの連携
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- fern and some key binds
vim.keymap.set("n", "k", "gk", {})
vim.keymap.set("n", "j", "gj", {})
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>", {})
vim.keymap.set("n", "<CR><CR>", "<C-w>w", {})
vim.g["fern#default_hidden"] = 1
-- vim.g["fern#renderer"] = "nerdfont"
vim.api.nvim_set_keymap("n", "<C-b>", ":Fern . -reveal=% -drawer -toggle<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>r", ":Fern . -reveal=%<CR>", { noremap = true, silent = true })

-- formatter and linter settings by none-ls
local prettier = require("prettier")

prettier.setup({
	bin = "prettier", -- or `'prettierd'` (v0.23.3+)
	filetypes = {
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"less",
		"markdown",
		"scss",
		"typescript",
		"typescriptreact",
		"yaml",
	},
})

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

prettier.setup({
	["null-ls"] = {
		condition = function()
			return prettier.config_exists({
				-- if `false`, skips checking `package.json` for `"prettier"` key
				check_package_json = true,
			})
		end,
		runtime_condition = function(params)
			-- return false to skip running prettier
			return true
		end,
		timeout = 5000,
	},
})

-- 診断情報の常時表示設定
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- ここで波線や他の記号を指定できます
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- local augroup = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

null_ls.setup({
	debug = false,
	sources = {
		formatting.stylua,
		formatting.black,
		formatting.isort,
		formatting.prettier,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- vim.lsp.buf.formatting_sync()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})

local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		-- 保存時に自動でフォーマットを実行
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
		-- 診断情報の表示設定
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.diagnostic.open_float(nil, { focusable = true })
			end,
		})
	end,
})
