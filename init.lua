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
-- ファイル変更検知。自動読み込み設定
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})
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
vim.opt.relativenumber = true

-- folder settings
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
-- vim.o.foldtext = "" -- 任意; 既定の折り畳み表示が嫌いな人用

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
			"zootedb0t/citruszest.nvim",
			lazy = false,
			priority = 1000,
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
					panel = {
						enabled = true,
						auto_refresh = true,
						layout = {
							position = "right",
							ratio = 0.3,
						},
					},
					copilot_node_command = "node",
				})
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
				window = {
					layout = "vertical",
					-- width = 80, -- Fixed width in columns
					-- height = 20, -- Fixed height in rows
					border = "rounded", -- 'single', 'double', 'rounded', 'solid'
					-- title = "🤖 AI Assistant",
					-- zindex = 100, -- Ensure window stays on top
				},
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
						-- theme = "auto",
						theme = "powerline_dark",
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
					winbar = {
						lualine_a = { "tabs" },
						-- lualine_b = { "branch", "diff", "diagnostics" },
						lualine_c = {
							"filename",
							{
								"navic",
								color_correction = "dynamic",
								navic_opts = nil,
							},
						},
						lualine_x = { "lsp_status" },
						lualine_y = { "os.date('%H:%M:%S')", "data", "require'lsp-status'.status()" },
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch", "diff", "diagnostics" },
						lualine_c = {
							-- "filename",
							-- {
							--   "navic",
							--   color_correction = "dynamic",
							--   navic_opts = nil,
							-- },
						},
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
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})

				vim.lsp.config("rust_analyzer", {
					settings = {
						["rust-analyzer"] = {
							diagnostics = {
								enable = true,
								disabled = { "unresolved-proc-macro" }, -- example: disable a specific diagnostic
							},
							checkOnSave = {
								command = "clippy",
							},
							assist = {
								importGranularity = "module",
								importPrefix = "by_self",
							},
							formatting = {
								enable = true,
							},
						},
					},
				})
			end,
		},
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				{ "neovim/nvim-lspconfig" },
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
			init = function()
				require("gitsigns").setup()
			end,
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
					word_diff = true,
					on_attach = function(bufnr)
						local gitsigns = require("gitsigns")

						local function map(mode, l, r, opts)
							opts = opts or {}
							opts.buffer = bufnr
							vim.keymap.set(mode, l, r, opts)
						end

						-- Navigation
						map("n", "]c", function()
							if vim.wo.diff then
								vim.cmd.normal({ "]c", bang = true })
							else
								gitsigns.nav_hunk("next")
							end
						end)

						map("n", "[c", function()
							if vim.wo.diff then
								vim.cmd.normal({ "[c", bang = true })
							else
								gitsigns.nav_hunk("prev")
							end
						end)

						-- Actions
						map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage_hunk" })
						map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset_hunc" })

						map("v", "<leader>hs", function()
							gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
						end)

						map("v", "<leader>hr", function()
							gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
						end)

						map("n", "<leader>hS", gitsigns.stage_buffer)
						map("n", "<leader>hR", gitsigns.reset_buffer)
						map("n", "<leader>hp", gitsigns.preview_hunk)
						map("n", "<leader>hi", gitsigns.preview_hunk_inline)

						map("n", "<leader>hb", function()
							gitsigns.blame_line({ full = true })
						end)

						map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })

						map("n", "<leader>hD", function()
							gitsigns.diffthis("~")
						end, { desc = "diff diss in split" })

						map("n", "<leader>hQ", function()
							gitsigns.setqflist("all")
						end)
						map("n", "<leader>hq", gitsigns.setqflist, { desc = "set quick fix list" })

						-- Toggles
						map(
							"n",
							"<leader>tb",
							gitsigns.toggle_current_line_blame,
							{ desc = "toggle current line blame" }
						)
						map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "toggle word diff" })

						-- Text object
						-- map({ "o", "x" }, "ih", gitsigns.select_hunk)
					end,
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
		-- {
		-- 	"nvim-neo-tree/neo-tree.nvim",
		-- 	branch = "v3.x",
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"MunifTanjim/nui.nvim",
		-- 		"nvim-tree/nvim-web-devicons", -- optional, but recommended
		-- 	},
		-- 	lazy = false, -- neo-tree will lazily load itself
		-- 	config = function()
		-- 		vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>")
		-- 	end,
		-- },
		{
			"stevearc/oil.nvim",
			---@module 'oil'
			---@type oil.SetupOpts
			opts = {},
			-- Optional dependencies
			-- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
			dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
			-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
			lazy = false,
		},
		{
			"andersevenrud/nvim_context_vt",
		},
		{
			"MaximilianLloyd/ascii.nvim",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"goolord/alpha-nvim",
			config = function()
				require("alpha").setup(require("alpha.themes.startify").config)
			end,
			opts = function()
				-- require("alpha").setup(require("alpha.themes.dashboard").config)
				local top = require("alpha.themes.startify")
				-- top.section.header.val = require("ascii").art.computers.linux.linux_rules
				top.section.header.val = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣶⣦⣄⡀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⡆⠀⢀⣴⣿⣿⣿⣿⠿⠟⠛⠛⠛⠻⠿⣿⣿⣿⣿⣦⡀⠀⢰⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀ And you don't seem to understand
⠀⠀⠀⠀⢀⣴⣿⣿⣿⠟⠉⠀⣴⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣦⠀⠉⠻⢿⣿⣿⣦⡀⠀⠀⠀⠀⠀ A shame you seemed an honest man
⠀⠀⢀⣴⣿⣿⡿⠋⠀⠀⠀⣼⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣧⠀⠀⠀⠙⢿⣿⣿⣦⡀⠀⠀⠀ And all the fears you hold so dear
⠀⣰⣿⣿⡿⠉⠀⠀⠀⠀⢰⣿⣿⣿⠁⠀⠀⠀⠀⣤⣾⣿⣿⣿⣷⣦⠀⠀⠀⠀⠈⣿⣿⣿⡆⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀ Will turn to whisper in your ear
⣼⣿⡿⡏⠀⠀⠀⠀⠀⠀⣼⣿⣿⡏⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⢸⣿⣿⣷⠀⠀⠀⠀⠀⠀⢹⣿⣿⣧⠀ And you know what they say might hurt you
⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢿⣿⣿⡇⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⠀ And you know that it means so much
⠘⣿⣿⣷⡄⠀⠀⠀⠀⠀⢸⣿⣿⣷⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⣼⣿⣿⡏⠀⠀⠀⠀⠀⢀⣾⣿⣿⠏⠀ And you don't even feel a thing
⠀⠈⠻⣿⣿⣦⣄⠀⠀⠀⠀⢿⣿⣿⣇⠀⠀⠀⠀⠀⠉⠛⠛⠛⠉⠀⠀⠀⠀⠀⣸⣿⣿⣿⠁⠀⠀⠀⣠⣴⣿⣿⠟⠁⠀⠀
⠀⠀⠀⠈⠻⣿⣿⣷⣤⡀⠀⠘⢿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⡿⠃⠀⢀⣠⣾⣿⣿⠿⠁⠀⠀⠀⠀ I am falling
⠀⠀⣠⣤⡀⠈⠻⢿⣿⣿⣶⠀⠀⠻⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⣠⣤⣾⣿⣿⡿⠏⠁⠀⣴⣿⣿⣿⠟⠉⢀⣤⣄⠀⠀⠀ I am fading
⠀⠘⢿⢿⠇⠀⠀⠀⠉⠛⠛⠀⠀⠀⠈⠙⠿⣿⣿⣿⣷⠀⠀⠀⣾⣿⣿⣿⠿⠁⠀⠀⠀⠀⠙⠛⠋⠀⠀⠀⠸⣿⣿⠇⠀⠀ I have lost it all
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⠀⠀⠀⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢰⣵⣷⣄⠀⠀⠀⠀⠀⢀⣿⣿⣿⠀⠀⠀⣿⣿⣿⡄⠀⠀⠀⠀⠀⣠⣾⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣷⣦⣄⣀⣤⣾⣿⡿⠋⠀⠀⠀⠘⣿⣿⣷⣤⣀⣠⣤⣾⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⣿⣿⡟⠛⠁⠀⠀⠀⠀⠀⠀⠈⠘⠿⢿⣿⣿⠻⠏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

				top.section.header.val = vim.split(top.section.header.val, "\n", { trimempty = true })
				-- top.section.header.val = top.section.header.val .. require("ascii").art.text.neovim.sharp

				return top.opts
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
			"akinsho/toggleterm.nvim",
			version = "*",
			config = true,
			init = function()
				require("toggleterm").setup({
					size = 100,
					open_mapping = { [[<c-t>]], [[<c-g>]] },
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
				vim.keymap.set("n", "<C-g>", "<cmd>ToggleTerm direction=horizontal size=15<CR>")
				vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm direction=float size=100<CR>")
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
		{
			"NStefan002/screenkey.nvim",
			lazy = false,
			version = "*", -- or branch = "main", to use the latest commit
		},
		{
			"hat0uma/csvview.nvim",
			---@module "csvview"
			---@type CsvView.Options
			opts = {
				parser = { comments = { "#", "//" } },
				keymaps = {
					-- Text objects for selecting fields
					textobject_field_inner = { "if", mode = { "o", "x" } },
					textobject_field_outer = { "af", mode = { "o", "x" } },
					-- Excel-like navigation:
					-- Use <Tab> and <S-Tab> to move horizontally between fields.
					-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
					-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
					jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
					jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
					jump_next_row = { "<Enter>", mode = { "n", "v" } },
					jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
				},
			},
			cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
		},
		{
			"sarrisv/readermode.nvim",
			opts = {},
		},
		{
			"shellRaining/hlchunk.nvim",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				require("hlchunk").setup({
					chunk = {
						enable = true,
					},
					indent = {
						enable = false,
					},
					line_num = {
						enable = true,
					},
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
-- require("mason-lspconfig").setup({ automatic_enable = true })
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "ts_ls", "rust_analyzer" }, --"prettier", "prettierd", "black", "isort", "stylua" },
})
vim.keymap.set("n", "<Leader>=", "<C-w>=", { desc = "均等なウィンドウサイズに調整" })

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
		-- { name = "copilot" },
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

-- require("gitsigns").setup()

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
		formatting.prettierd,
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

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	callback = function(args)
-- 		vim.lsp.start({
-- 			name = "rust-analyzer",
-- 			cmd = { "rust-analyzer" },
-- 			root_dir = vim.fs.dirname(vim.fs.find({ "Cargo.toml", ".git" }, { upward = true })[1]),
-- 			settings = {
-- 				["rust-analyzer"] = {
-- 					diagnostics = {
-- 						enable = true,
-- 						disabled = { "unresolved-proc-macro" }, -- example: disable a specific diagnostic
-- 					},
-- 					checkOnSave = {
-- 						command = "clippy",
-- 					},
-- 					assist = {
-- 						importGranularity = "module",
-- 						importPrefix = "by_self",
-- 					},
-- 					formatting = {
-- 						enable = true,
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- 	callback = function(ev)
-- 		-- 保存時に自動フォーマット
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			pattern = { "*.rs" }, -- none-lsでフォーマッターを使用しない拡張子のみ
-- 			callback = function()
-- 				vim.lsp.buf.format({
-- 					buffer = ev.buf,
-- 					async = false,
-- 				})
-- 				-- vim.lsp.buf.formatting_sync()
-- 				-- vim.lsp.buf.format({ async = false })
-- 				local last_line = vim.fn.getline("$")
-- 				-- 最終行に改行を挟む
-- 				if last_line ~= "" then
-- 					vim.fn.append(vim.fn.line("$"), "")
-- 				end
-- 			end,
-- 		})
-- 	end,
-- })

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

-- ====================================================================
-- ターミナルバッファの背景色のみを上書きする設定
-- ====================================================================

