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
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- マウスを有効に
vim.opt.mouse = "a"
vim.opt.laststatus = 3

-- vim.opt.winblend = 100
vim.opt.pumblend = 0
vim.opt.termguicolors = true
vim.g.editor_config = true

-- 背景透過
-- highlight Normal ctermbg=NONE guibg=NONE
-- highlight NonText ctermbg=NONE guibg=NONE
-- highlight LineNr ctermbg=NONE guibg=NONE
-- highlight Folded ctermbg=NONE guibg=NONE
-- highlight EndOfBuffer ctermbg=NONE guibg=NONE

-- set update time for git plugin
vim.opt.updatetime = 300

-- spell check
-- vim.opt.spell = true

-- カーソル位置強調
-- vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true

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
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			setup = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "javascript", "rust" },
					sync_install = false,
					auto_install = true,
				})
			end,
		},
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
		{ "folke/which-key.nvim", lazy = false },

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
		-- copilot
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			config = function()
				require("copilot").setup({
					suggestion = { enabled = false },
					panel = { enabled = false },
					copilot_node_command = "node",
				})
			end,
		},
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end,
		},
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup({
					suggestion = { enabled = false },
					panel = { enabled = false },
				})
			end,
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			branch = "main",
			dependencies = {
				{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				debug = true, -- Enable debugging
				-- See Configuration section for rest
			},
			-- See Commands section for default commands if you want to lazy load on them
			init = function()
				require("CopilotChat").setup({
					-- 回答を日本語にしてくれる設定に変更する
					show_help = "yes",
					prompts = {
						Explain = {
							prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
							mapping = "<leader>ce",
							description = "コードの説明をお願いする",
						},
						Review = {
							prompt = "/COPILOT_REVIEW コードを日本語でレビューしてください。",
							mapping = "<leader>cr",
							description = "コードのレビューをお願いする",
						},
						Fix = {
							prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
							mapping = "<leader>cf",
							description = "コードの修正をお願いする",
						},
						Optimize = {
							prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
							mapping = "<leader>co",
							description = "コードの最適化をお願いする",
						},
						Docs = {
							prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
							mapping = "<leader>cd",
							description = "コードのドキュメント作成をお願いする",
						},
						Tests = {
							prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
							mapping = "<leader>ct",
							description = "テストコード作成をお願いする",
						},
						FixDiagnostic = {
							prompt = "コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。",
							mapping = "<leader>cd",
							description = "コードの修正をお願いする",
							selection = require("CopilotChat.select").diagnostics,
						},
						Commit = {
							prompt = "実装差分に対するコミットメッセージを日本語で記述してください。",
							mapping = "<leader>cco",
							description = "コミットメッセージの作成をお願いする",
							selection = require("CopilotChat.select").gitdiff,
						},
						CommitStaged = {
							prompt = "ステージ済みの変更に対するコミットメッセージを日本語で記述してください。",
							mapping = "<leader>cs",
							description = "ステージ済みのコミットメッセージの作成をお願いする",
							selection = function(source)
								return require("CopilotChat.select").gitdiff(source, true)
							end,
						},
					},
				})
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
			init = function()
				require("lualine").setup({
					options = {
						icons_enabled = true,
						theme = "auto",
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
						disabled_filetypes = {
							statusline = {},
							winbar = {},
						},
						ignore_focus = {},
						always_divide_middle = true,
						globalstatus = true,
						refresh = {
							statusline = 500,
							tabline = 1000,
							winbar = 1000,
						},
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch", "diff", "diagnostics" },
						lualine_c = { "filename" },
						lualine_x = { "encoding", "fileformat", "filetype" },
						lualine_y = { "progress" },
						lualine_z = { "selectioncount" },
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { "filename" },
						lualine_x = { "location" },
						lualine_y = {},
						lualine_z = {},
					},
					tabline = {},
					winbar = {},
					inactive_winbar = {},
					extensions = {},
				})
			end,
		},

		-- local plugins need to be explicitly configured with dir
		-- { dir = "~/projects/secret.nvim" },

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
		{ "neovim/nvim-lspconfig" },
		{ "williamboman/mason.nvim" },
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				{
					"SmiteshP/nvim-navbuddy",
					dependencies = {
						"SmiteshP/nvim-navic",
						"MunifTanjim/nui.nvim",
					},
					opts = { lsp = { auto_attach = true } },
					init = function()
						require("nvim-navbuddy").setup({
							window = {
								size = { height = "30%", width = "100%" },
								position = { row = "100%", col = "50%" },
							},
							-- set keybind
							vim.keymap.set(
								"n",
								"<leader>nn",
								"<cmd>lua require('nvim-navbuddy').open()<CR>",
								{ noremap = true, silent = true }
							),
						})
					end,
				},
			},
		},
		{ "L3MON4D3/LuaSnip" },

		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		-- {
		-- 	"nvimdev/lspsaga.nvim",
		-- 	config = function()
		-- 		require("lspsaga").setup({})
		-- 	end,
		-- 	dependencies = {
		-- 		"nvim-treesitter/nvim-treesitter", -- optional
		-- 		"nvim-tree/nvim-web-devicons", -- optional
		-- 	},
		-- },
		{
			"folke/trouble.nvim",
			opts = {}, -- for default options, refer to the configuration section for custom setup.
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=true<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
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
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
			init = function()
				local highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				}

				local hooks = require("ibl.hooks")
				-- create the highlight groups in the highlight setup hook, so they are reset
				-- every time the colorscheme changes
				hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
					vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
					vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
					vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
					vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
					vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
					vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
					vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
				end)

				require("ibl").setup({ indent = { highlight = highlight } })
			end,
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function(bufnr)
				local function my_on_attach(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
					vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
					vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
				end

				require("nvim-tree").setup({
					on_attach = my_on_attach,
					filters = {
						git_ignored = false,
						custom = {
							"^\\.git",
							"^node_modules",
						},
					},
				})
			end,
		},
		{
			"andersevenrud/nvim_context_vt",
		},
		{
			"goolord/alpha-nvim",
			config = function()
				require("alpha").setup(require("alpha.themes.startify").config)
			end,
		},
		{
			"SmiteshP/nvim-navic",
			config = function()
				require("nvim-navic").setup({
					lsp = {
						auto_attach = true,
					},
					highlight = true,
				})
			end,
			-- init = function()
			-- 	vim.g.navic_silence = true
			-- 	vim.lsp.on_attach(function(client, buffer)
			-- 		if client.supports_method("textDocument/documentSymbol") then
			-- 			require("nvim-navic").attach(client, buffer)
			-- 		end
			-- 	end)
			-- end,
			-- opts = function()
			-- 	return {
			-- 		separator = " ",
			-- 		highlight = true,
			-- 		depth_limit = 5,
			-- 		icons = LazyVim.config.icons.kinds,
			-- 		lazy_update_context = true,
			-- 	}
			-- end,
			init = function()
				local navic = require("nvim-navic")
				navic.setup({
					icons = {
						File = "󰈙 ",
						Module = " ",
						Namespace = "󰌗 ",
						Package = " ",
						Class = "󰌗 ",
						Method = "󰆧 ",
						Property = " ",
						Field = " ",
						Constructor = " ",
						Enum = "󰕘",
						Interface = "󰕘",
						Function = "󰊕 ",
						Variable = "󰆧 ",
						Constant = "󰏿 ",
						String = "󰀬 ",
						Number = "󰎠 ",
						Boolean = "◩ ",
						Array = "󰅪 ",
						Object = "󰅩 ",
						Key = "󰌋 ",
						Null = "󰟢 ",
						EnumMember = " ",
						Struct = "󰌗 ",
						Event = " ",
						Operator = "󰆕 ",
						TypeParameter = "󰊄 ",
					},
					lsp = {
						auto_attach = true,
						preference = nil,
					},
					highlight = false,
					separator = " > ",
					depth_limit = 0,
					depth_limit_indicator = "..",
					safe_output = true,
					lazy_update_context = false,
					click = false,
					format_text = function(text)
						return text
					end,
				})
			end,
		},
		-- {
		-- 	"rest-nvim/rest.nvim",
		-- },
		{
			"toppair/peek.nvim",
			event = { "VeryLazy" },
			build = "deno task --quiet build:fast",
			config = function()
				require("peek").setup()
				vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
				vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
			end,
		},
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			ft = { "markdown" },
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
		},

		-- install with yarn or npm
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
		},
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = true,
			init = function()
				require("toggleterm").setup({
					size = 100,
					open_mapping = [[<c-t>]],
					hide_numbers = true,
					shade_filetypes = {},
					shade_terminals = true,
					shading_factor = 2,
					start_in_insert = true,
					insert_mappings = true,
					persist_size = true,
					direction = "float",
					close_on_exit = true,
					float_opts = {
						border = "double",
						-- border = 'single' | 'double' | 'shadow' | 'curved'
					},
				})
			end,
		},
		{
			"brenoprata10/nvim-highlight-colors",
			init = function()
				require("nvim-highlight-colors").setup({})
			end,
		},
		{
			"danymat/neogen",
			config = true,
			-- Uncomment next line if you want to follow only stable versions
			-- version = "*",
			setup = function()
				require("neogen").setup({
					snippet_engine = "luasnip",
					input_after_comment = true,
				})
			end,
		},

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

-- プラグインの設定
require("mason").setup()
require("mason-lspconfig").setup({ automatic_enable = true })

-- lspのハンドラーに設定
-- capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { focusable = true })

-- lspの設定後に追加
vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<S-tab>"] = cmp.mapping.select_prev_item(),
		-- ["<tab>"] = cmp.mapping.select_next_item(),
		["<Tab>"] = vim.schedule_wrap(function(fallback)
			if cmp.visible() and has_words_before() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Enter>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "copilot" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
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

-- nvim-tree config
map("n", "<C-b>", "<Cmd>NvimTreeToggle<CR>", opts)

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

--  some key binds
vim.keymap.set("n", "k", "gk", {})
vim.keymap.set("n", "j", "gj", {})
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>", {})
vim.keymap.set("n", "<CR><CR>", "<C-w>w", {})
-- -- formatter and linter settings by none-ls
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

vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
})

null_ls.setup({
	debug = false,
	sources = {
		formatting.stylua,
		formatting.black,
		formatting.isort,
		formatting.prettier,
		formatting.clang_format,
		formatting.gofumpt,
		-- formatting.typstfmt,
		formatting.shfmt,
		diagnostics.codespell,
	},
	on_attach = function(client, bufnr)
		local navic = require("nvim-navic")
		local navbuddy = require("nvim-navbuddy")
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
			navbuddy.attach(client, bufnr)
		end
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- vim.lsp.buf.formatting_sync()
					vim.lsp.buf.format({ async = false })
					local last_line = vim.fn.getline("$")
					-- 最終行に改行を挟む
					if last_line ~= "" then
						vim.fn.append(vim.fn.line("$"), "")
					end
				end,
			})
		end
	end,
})

local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		local navic = require("nvim-navic")
		local navbuddy = require("nvim-navbuddy")
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
			navbuddy.attach(client, bufnr)
		end
		-- 保存時に自動でフォーマットを実行
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
				local last_line = vim.fn.getline("$")
				if last_line ~= "" then
					vim.fn.append(vim.fn.line("$"), "")
				end
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

lspconfig.tinymist.setup({
	single_file_support = true,
	offset_encoding = "utf-8",
	root_dir = function()
		return vim.fn.getcwd()
	end,
	settings = {},
})

-- 日本語入力ON時のカーソルの色を設定
-- vim.api.nvim_set_hl(0, "Normal", { ctermfg = "lightgray", ctermbg = "darkgray" })
-- vim.api.nvim_set_hl(0, "NonText", { ctermfg = "gray", ctermbg = "darkgray" })
-- -- ColorSchemeイベントを監視し、カラースキーム変更時に色を調整する
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.api.nvim_set_hl(0, "Normal", { ctermfg = "lightgray", ctermbg = "darkgray" })
-- 		vim.api.nvim_set_hl(0, "NonText", { ctermfg = "gray", ctermbg = "darkgray" })
-- 	end,
-- })

