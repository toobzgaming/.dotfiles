local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

-- Autocommand to source the file and run PackerSync on write to file

-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost init.lua source <afile> | PackerSync
--   augroup end
-- ]])

local has_packer, packer = pcall(require, "packer")
if not has_packer then
	print("Packer not found!")
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

if vim.g.vscode then
	-- if true then  -- Uncomment to chekcout vscode config in neovim
	-- VSCode extension
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_set_keymap

	keymap("", "<Space>", "<Nop>", opts)

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Keeping the view centered
	keymap("n", "<C-u>", "<C-u>zz", opts)
	keymap("n", "<C-d>", "<C-d>zz", opts)
	keymap("n", "<C-f>", "<C-f>zz", opts)
	keymap("n", "<C-b>", "<C-b>zz", opts)

	-- Keeping the search term centered
	keymap("n", "n", "nzz", opts)
	keymap("n", "N", "Nzz", opts)

	-- Switch between buffers
	keymap("n", "H", "<cmd>bp<cr>", opts)
	keymap("n", "L", "<cmd>bn<cr>", opts)

	-- Move text in visual mode
	keymap("v", "J", "<cmd>m '>+1<cr>gv=gv", opts)
	keymap("v", "K", "<cmd>m '<-2<cr>gv=gv", opts)

	-- Dont copy to registers on cut or paste
	keymap("n", "x", '"_x', opts)
	keymap("v", "p", '"_p', opts)

	-- Calling whichkey functionality in VSCode
	keymap("n", "<leader>", "<cmd>call VSCodeNotify('whichkey.show')<CR>", opts)
	keymap("x", "<leader>", "<cmd>call VSCodeNotify('whichkey.show')<CR>", opts)

	vim.opt.clipboard:append({ "unnamedplus" })
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.scrolloff = 8
	vim.opt.termguicolors = true

	packer.startup(function(use)
		use("kylechui/nvim-surround")
		use("windwp/nvim-autopairs")
		use("ggandor/leap.nvim")
		use("numToStr/Comment.nvim")
		if packer_bootstrap then
			require("packer").sync()
		end
	end)

	local has_surround, surround = pcall(require, "nvim-surround")
	if has_surround then
		surround.setup()
	end

	local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
	if has_autopairs then
		autopairs.setup()
	end

	local has_leap, leap = pcall(require, "leap")
	if has_leap then
		leap.add_default_mappings()
	end

	local has_comment, comment = pcall(require, "Comment")
	if has_comment then
		comment.setup()
	end

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		callback = function(_)
			vim.cmd([[TSDisable highlight]])
		end,
	})
else
	-- ordinary Neovim

	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_set_keymap

	keymap("", "<Space>", "<Nop>", opts)

	-- keep cursorline in middle of screen during scrolling
	keymap("n", "<C-u>", "<C-u>zz", opts)
	keymap("n", "<C-d>", "<C-d>zz", opts)
	keymap("n", "<C-f>", "<C-f>zz", opts)
	keymap("n", "<C-b>", "<C-b>zz", opts)

	-- keep cursorline in the middle of the screen during search navigation
	keymap("n", "n", "nzzzv", opts)
	keymap("n", "N", "Nzzzv", opts)

	-- keep cursorline in the middle of the screen during join operations
	keymap("n", "J", "mzJ`z", opts)

	-- moving text in visual mode
	keymap("v", "J", "<cmd>m '>+1<cr>gv=gv", opts)
	keymap("v", "K", "<cmd>m '<-2<cr>gv=gv", opts)

	-- moving between buffers
	keymap("n", "H", "<cmd>bp<cr>", opts)
	keymap("n", "L", "<cmd>bn<cr>", opts)

	-- moving between splits
	keymap("n", "<C-h>", "<C-w>h", opts)
	keymap("n", "<C-j>", "<C-w>j", opts)
	keymap("n", "<C-k>", "<C-w>k", opts)
	keymap("n", "<C-l>", "<C-w>l", opts)

	-- delete without copying to registers
	keymap("n", "x", '"_x', opts)
	keymap("v", "p", '"_p', opts)

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Netrw config
	vim.g.netrw_keepdir = 0
	vim.g.netrw_winsize = 16
	vim.g.netrw_banner = 0
	vim.g.netrw_browse_split = 0

	-- Netrw disable b/ using nvim-tree
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- Neovide
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_transparency = 1.0
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_refresh_rate = 60

	vim.o.completeopt = "menuone,noselect,preview"

	-- Setup GUI Fonts
	vim.opt.guifont = "FiraCode Nerd Font:h12"

	-- Options
	vim.opt.scrolloff = 8
	vim.opt.backup = false
	vim.opt.clipboard:append({ "unnamedplus" })
	vim.opt.cmdheight = 2
	vim.opt.hlsearch = true
	vim.opt.mouse = "a"
	vim.opt.pumheight = 10
	vim.opt.showmode = false
	vim.opt.showtabline = 2
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.smartindent = true
	vim.opt.breakindent = true
	vim.opt.splitbelow = true
	vim.opt.splitright = true
	vim.opt.swapfile = false
	vim.opt.updatetime = 250
	vim.opt.timeoutlen = 300
	vim.opt.undofile = true
	vim.opt.writebackup = false
	vim.opt.expandtab = true
	vim.opt.shiftwidth = 4
	vim.opt.shiftround = true
	vim.opt.tabstop = 4
	vim.opt.relativenumber = true
	vim.opt.number = true
	vim.opt.numberwidth = 4
	vim.opt.signcolumn = "yes"
	vim.opt.wrap = true
	vim.opt.colorcolumn = { "80" }
	vim.opt.cursorline = true
	vim.opt.cursorcolumn = true
	vim.opt.termguicolors = true
	vim.opt.list = true
	vim.opt.listchars = { eol = "↵", tab = ">-", space = "·", nbsp = "␣", trail = "~", multispace = "|···" }
	vim.opt.foldcolumn = "auto"
	vim.opt.cmdheight = 1

	packer.startup(function(use)
		use({
			"NeogitOrg/neogit",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "sindrets/diffview.nvim" },
				{ "nvim-telescope/telescope.nvim" },
			},
			config = function()
				local neogit = require("neogit")
				neogit.setup({})
			end,
		})
		use("wbthomason/packer.nvim")
		use("habamax/vim-asciidoctor")
		use("Mofiqul/dracula.nvim")
		-- Lualine
		use("nvim-lualine/lualine.nvim")
		use("kyazdani42/nvim-web-devicons")
		-- Telescope
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		})
		use({
			"nvim-telescope/telescope.nvim",
			tag = "0.1.x",
			requires = { { "nvim-lua/plenary.nvim" } },
		})
		-- Ease of life stuff
		use("kylechui/nvim-surround")
		use("windwp/nvim-autopairs")
		use("windwp/nvim-ts-autotag")
		use("numToStr/Comment.nvim")
		-- Leap
		use("ggandor/leap.nvim")
		-- Display hexcodes as colors
		use("norcalli/nvim-colorizer.lua")
		-- Treesitter
		use({ "nvim-treesitter/nvim-treesitter", run = "<cmd>TSUpdate" })
		use("nvim-treesitter/playground")
		use("HiPhish/rainbow-delimiters.nvim")
		-- Undo Tree
		use("mbbill/undotree")
		-- Terminal
		use("akinsho/toggleterm.nvim")
		-- LSP
		use({
			"VonHeikemen/lsp-zero.nvim",
			branch = "v1.x",
			requires = {
				-- LSP Support
				{ "neovim/nvim-lspconfig" },
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },

				-- Autocompletion
				{ "hrsh7th/nvim-cmp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lua" },

				-- Snippets
				{ "L3MON4D3/LuaSnip" },
				{ "rafamadriz/friendly-snippets" },
			},
		})
		use({ "L3MON4D3/LuaSnip", run = "make install_jsregexp" })
		-- Zen mode
		use("folke/zen-mode.nvim")
		-- Orgmode
		use("nvim-orgmode/orgmode")
		-- Todo Comment
		use("folke/todo-comments.nvim")
		-- Syntax Highlights
		use("baskerville/vim-sxhkdrc")
		-- Indent
		use("lukas-reineke/indent-blankline.nvim")
		-- SwHKD highlights
		use("waycrate/swhkd-vim")
		use({
			"aznhe21/actions-preview.nvim",
			config = function()
				vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions)
			end,
		})
		-- Which key
		use("folke/which-key.nvim")
		use("barreiroleo/ltex-extra.nvim")
		use("echasnovski/mini.icons")
		use({
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
				{
					"s1n7ax/nvim-window-picker",
					version = "2.*",
					config = function()
						require("window-picker").setup({
							filter_rules = {
								include_current_win = false,
								autoselect_one = true,
								-- filter using buffer options
								bo = {
									-- if the file type is one of following, the window will be ignored
									filetype = { "neo-tree", "neo-tree-popup", "notify" },
									-- if the buffer type is one of following, the window will be ignored
									buftype = { "terminal", "quickfix" },
								},
							},
						})
					end,
				},
			},
			config = function()
				-- If you want icons for diagnostic errors, you'll need to define them somewhere:
				vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
				vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
				vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
				vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

				require("neo-tree").setup({
					close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
					popup_border_style = "rounded",
					enable_git_status = true,
					enable_diagnostics = true,
					open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
					sort_case_insensitive = false, -- used when sorting files and directories in the tree
					sort_function = nil, -- use a custom function for sorting files and directories in the tree
					-- sort_function = function (a,b)
					--       if a.type == b.type then
					--           return a.path > b.path
					--       else
					--           return a.type > b.type
					--       end
					--   end , -- this sorts files and directories descendantly
					source_selector = {
						winbar = false,
						statusline = false,
					},
					default_component_configs = {
						container = {
							enable_character_fade = true,
						},
						indent = {
							indent_size = 2,
							padding = 1, -- extra padding on left hand side
							-- indent guides
							with_markers = true,
							indent_marker = "│",
							last_indent_marker = "└",
							highlight = "NeoTreeIndentMarker",
							-- expander config, needed for nesting files
							with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
							expander_collapsed = "",
							expander_expanded = "",
							expander_highlight = "NeoTreeExpander",
						},
						icon = {
							folder_closed = "",
							folder_open = "",
							folder_empty = "󰜌",
							-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
							-- then these will never be used.
							default = "*",
							highlight = "NeoTreeFileIcon",
						},
						modified = {
							symbol = "[+]",
							highlight = "NeoTreeModified",
						},
						name = {
							trailing_slash = false,
							use_git_status_colors = true,
							highlight = "NeoTreeFileName",
						},
						git_status = {
							symbols = {
								-- Change type
								added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
								modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
								deleted = "✖", -- this can only be used in the git_status source
								renamed = "󰁕", -- this can only be used in the git_status source
								-- Status type
								untracked = "",
								ignored = "",
								unstaged = "󰄱",
								staged = "",
								conflict = "",
							},
						},
						-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
						file_size = {
							enabled = true,
							required_width = 64, -- min width of window required to show this column
						},
						type = {
							enabled = true,
							required_width = 122, -- min width of window required to show this column
						},
						last_modified = {
							enabled = true,
							required_width = 88, -- min width of window required to show this column
						},
						created = {
							enabled = true,
							required_width = 110, -- min width of window required to show this column
						},
						symlink_target = {
							enabled = false,
						},
					},
					-- A list of functions, each representing a global custom command
					-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
					-- see `:h neo-tree-custom-commands-global`
					commands = {},
					window = {
						position = "left",
						width = 40,
						mapping_options = {
							noremap = true,
							nowait = true,
						},
						mappings = {
							["<space>"] = {
								"toggle_node",
								nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
							},
							["<2-LeftMouse>"] = "open",
							["<cr>"] = "open",
							["<esc>"] = "cancel", -- close preview or floating neo-tree window
							["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
							-- Read `# Preview Mode` for more information
							["l"] = "focus_preview",
							["S"] = "open_split",
							["s"] = "open_vsplit",
							-- ["S"] = "split_with_window_picker",
							-- ["s"] = "vsplit_with_window_picker",
							["t"] = "open_tabnew",
							-- ["<cr>"] = "open_drop",
							-- ["t"] = "open_tab_drop",
							["w"] = "open_with_window_picker",
							--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
							["C"] = "close_node",
							-- ['C'] = 'close_all_subnodes',
							["z"] = "close_all_nodes",
							--["Z"] = "expand_all_nodes",
							["a"] = {
								"add",
								-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
								-- some commands may take optional config options, see `:h neo-tree-mappings` for details
								config = {
									show_path = "none", -- "none", "relative", "absolute"
								},
							},
							["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
							["d"] = "delete",
							["r"] = "rename",
							["y"] = "copy_to_clipboard",
							["x"] = "cut_to_clipboard",
							["p"] = "paste_from_clipboard",
							["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
							-- ["c"] = {
							--  "copy",
							--  config = {
							--    show_path = "none" -- "none", "relative", "absolute"
							--  }
							--}
							["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
							["q"] = "close_window",
							["R"] = "refresh",
							["?"] = "show_help",
							["<"] = "prev_source",
							[">"] = "next_source",
							["i"] = "show_file_details",
						},
					},
					nesting_rules = {},
					filesystem = {
						filtered_items = {
							visible = false, -- when true, they will just be displayed differently than normal items
							hide_dotfiles = false,
							hide_gitignored = false,
							hide_hidden = false, -- only works on Windows for hidden files/directories
							hide_by_name = {
								--"node_modules"
							},
							hide_by_pattern = { -- uses glob style patterns
								--"*.meta",
								--"*/src/*/tsconfig.json",
							},
							always_show = { -- remains visible even if other settings would normally hide it
								--".gitignored",
							},
							always_show_by_pattern = { -- uses glob style patterns
								--".env*",
							},
							never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
								--".DS_Store",
								--"thumbs.db"
							},
							never_show_by_pattern = { -- uses glob style patterns
								--".null-ls_*",
							},
						},
						follow_current_file = {
							enabled = false, -- This will find and focus the file in the active buffer every time
							--               -- the current file is changed while the tree is open.
							leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
						},
						group_empty_dirs = false, -- when true, empty folders will be grouped together
						hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
						-- in whatever position is specified in window.position
						-- "open_current",  -- netrw disabled, opening a directory opens within the
						-- window like netrw would, regardless of window.position
						-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
						use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
						-- instead of relying on nvim autocmd events.
						window = {
							mappings = {
								["<bs>"] = "navigate_up",
								["."] = "set_root",
								["H"] = "toggle_hidden",
								["/"] = "fuzzy_finder",
								["D"] = "fuzzy_finder_directory",
								["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
								-- ["D"] = "fuzzy_sorter_directory",
								["f"] = "filter_on_submit",
								["<c-x>"] = "clear_filter",
								["[g"] = "prev_git_modified",
								["]g"] = "next_git_modified",
								["o"] = {
									"show_help",
									nowait = false,
									config = { title = "Order by", prefix_key = "o" },
								},
								["oc"] = { "order_by_created", nowait = false },
								["od"] = { "order_by_diagnostics", nowait = false },
								["og"] = { "order_by_git_status", nowait = false },
								["om"] = { "order_by_modified", nowait = false },
								["on"] = { "order_by_name", nowait = false },
								["os"] = { "order_by_size", nowait = false },
								["ot"] = { "order_by_type", nowait = false },
								-- ['<key>'] = function(state) ... end,
							},
							fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
								["<down>"] = "move_cursor_down",
								["<C-n>"] = "move_cursor_down",
								["<up>"] = "move_cursor_up",
								["<C-p>"] = "move_cursor_up",
								-- ['<key>'] = function(state, scroll_padding) ... end,
							},
						},

						commands = {}, -- Add a custom command or override a global one using the same function name
					},
					buffers = {
						follow_current_file = {
							enabled = true, -- This will find and focus the file in the active buffer every time
							--              -- the current file is changed while the tree is open.
							leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
						},
						group_empty_dirs = true, -- when true, empty folders will be grouped together
						show_unloaded = true,
						window = {
							mappings = {
								["bd"] = "buffer_delete",
								["<bs>"] = "navigate_up",
								["."] = "set_root",
								["o"] = {
									"show_help",
									nowait = false,
									config = { title = "Order by", prefix_key = "o" },
								},
								["oc"] = { "order_by_created", nowait = false },
								["od"] = { "order_by_diagnostics", nowait = false },
								["om"] = { "order_by_modified", nowait = false },
								["on"] = { "order_by_name", nowait = false },
								["os"] = { "order_by_size", nowait = false },
								["ot"] = { "order_by_type", nowait = false },
							},
						},
					},
					git_status = {
						window = {
							position = "float",
							mappings = {
								["A"] = "git_add_all",
								["gu"] = "git_unstage_file",
								["ga"] = "git_add_file",
								["gr"] = "git_revert_file",
								["gc"] = "git_commit",
								["gp"] = "git_push",
								["gg"] = "git_commit_and_push",
								["o"] = {
									"show_help",
									nowait = false,
									config = { title = "Order by", prefix_key = "o" },
								},
								["oc"] = { "order_by_created", nowait = false },
								["od"] = { "order_by_diagnostics", nowait = false },
								["om"] = { "order_by_modified", nowait = false },
								["on"] = { "order_by_name", nowait = false },
								["os"] = { "order_by_size", nowait = false },
								["ot"] = { "order_by_type", nowait = false },
							},
						},
					},
				})

				vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
			end,
		})
		use({
			"glepnir/lspsaga.nvim",
			branch = "main",
			requires = {
				{ "nvim-tree/nvim-web-devicons" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
		})
		use("onsails/lspkind.nvim")
		use("simrat39/symbols-outline.nvim")
		use("delphinus/vim-firestore")
		use("lewis6991/gitsigns.nvim")
		-- lazy.nvim
		use("folke/noice.nvim")
		use("MunifTanjim/nui.nvim")
		use("rcarriga/nvim-notify")
		use("davidmh/cspell.nvim")
		use({
			"nvimtools/none-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
		use({ "nvim-telescope/telescope-ui-select.nvim" })
		use({
			"mfussenegger/nvim-dap",
			requires = {
				{ "rcarriga/nvim-dap-ui" },
				{ "nvim-neotest/nvim-nio" },
				{ "williamboman/mason.nvim" },
				{ "jay-babu/mason-nvim-dap.nvim" },
			},
		})
		use({
			"goolord/alpha-nvim",
			requires = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("alpha").setup(require("alpha.themes.startify").config)
			end,
		})
		use({
			"MeanderingProgrammer/render-markdown.nvim",
			after = { "nvim-treesitter" },
			requires = { "echasnovski/mini.nvim", opt = true }, -- if you use the mini.nvim suite
			-- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
			-- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
			config = function()
				require("render-markdown").setup({})
			end,
		})
		use({
			"sotte/presenting.nvim",
			config = function()
				require("presenting").setup({})
			end,
		})
		-- use({
		-- 	"goolord/alpha-nvim",
		-- 	requires = {
		-- 		"nvim-tree/nvim-web-devicons",
		-- 		"nvim-lua/plenary.nvim",
		-- 	},
		-- 	config = function()
		-- 		require("alpha").setup(require("alpha.themes.dashboard").config)
		-- 	end,
		-- })
		-- -- Obsidian
		-- use({
		--     "epwalsh/obsidian.nvim",
		--     tag = "*", -- recommended, use latest release instead of latest commit
		--     requires = {
		--         -- Required.
		--         "nvim-lua/plenary.nvim",
		--
		--         -- see below for full list of optional dependencies 👇
		--     },
		--     config = function()
		--         require("obsidian").setup({
		--             workspaces = {
		--                 {
		--                     name = "personal",
		--                     path = "~/vaults/personal",
		--                 },
		--                 {
		--                     name = "work",
		--                     path = "~/vaults/work",
		--                 },
		--             },
		--             -- see below for full list of options 👇
		--         })
		--     end,
		-- })
		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
		end
	end)
	local has_colorizer, colorizer = pcall(require, colorizer)
	if has_colorizer then
		colorizer.setup()
	end
	local has_surround, surround = pcall(require, "nvim-surround")
	if has_surround then
		surround.setup()
	end

	local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
	if has_autopairs then
		autopairs.setup()
	end

	local has_comment, comment = pcall(require, "Comment")
	if has_comment then
		comment.setup()
	end

	local has_todo_comments, todo_comments = pcall(require, "todo-comments")

	if has_todo_comments then
		todo_comments.setup()
	end

	local has_leap, leap = pcall(require, "leap")
	if has_leap then
		leap.add_default_mappings()
	end

	local has_lspsaga, lspsaga = pcall(require, "lspsaga")
	if has_lspsaga then
		lspsaga.setup({})
	end

	local has_toggleterm, toggleterm = pcall(require, "toggleterm")
	if has_toggleterm then
		toggleterm.setup({
			size = 24,
			open_mapping = [[<c-`>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})

		keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", opts)
		keymap("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
	end
	local has_ibl, ibl = pcall(require, "ibl")
	if has_ibl then
		ibl.setup()
	end

	local has_dracula, _ = pcall(vim.cmd, "colorscheme dracula")
	-- Setup Colorscheme
	if not has_dracula then
		print("Colorscheme Dracula not found!")
	end

	local has_lualine, lualine = pcall(require, "lualine")
	if has_lualine then
		lualine.setup({
			options = {
				theme = "dracula",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_x = {
					-- {
					-- 	require("noice").api.status.message.get_hl,
					-- 	cond = require("noice").api.status.message.has,
					-- },
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has,
						color = { fg = "#ff9e64" },
					},
				},
			},
		})
	end

	local has_noice, noice = pcall(require, "noice")
	if has_noice then
		noice.setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
				progress = {
					throttle = 1000 / 1,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
	end

	local has_outline, outline = pcall(require, "symbols-outline")
	if has_outline then
		outline.setup()
	end

	local has_gitsigns, gitsigns = pcall(require, "gitsigns")
	if has_gitsigns then
		gitsigns.setup()
	end

	local has_nvimtree, nvimtree = pcall(require, "nvim-tree")
	if has_nvimtree then
		vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
		keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

		keymap("n", "<leader>tf", "<cmd>NvimTreeFindFile<cr>", opts)
		keymap("n", "<leader>te", "<cmd>NvimTreeToggle<cr>", opts)
	end

	keymap("n", "<esc>", "<cmd>nohlsearch<cr>", {})

	keymap("n", "<leader>z", "<cmd>ZenMode<cr>", opts)
	keymap("n", "<leader>tz", "<cmd>ZenMode<cr>", opts)

	keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)
	keymap("n", "<leader>tu", "<cmd>UndotreeToggle<cr>", opts)

	keymap("n", "<leader>ts", "<cmd>SymbolsOutline<cr>", opts)
	keymap("n", "<leader>tc", "<cmd>ColorizerToggle<cr>", opts)

	local has_neotree, neotree = pcall(require, "neo-tree")
	if has_neotree then
		keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", opts)
		keymap("n", "<leader>ne", "<cmd>Neotree toggle<cr>", opts)
		keymap("n", "<leader>ng", "<cmd>Neotree git_status<cr>", opts)
		keymap("n", "<leader>nb", "<cmd>Neotree buffers<cr>", opts)
		keymap("n", "<leader>ns", "<cmd>Neotree document_symbols<cr>", opts)
	end

	local has_ltex_extra, ltex_extra = pcall(require, "ltex_extra")
	if has_ltex_extra then
		keymap("n", "<leader>tl", "<cmd>lua require('ltex_extra').reload()<cr>", opts)
		ltex_extra.setup({
			-- table <string> : languages for witch dictionaries will be loaded, e.g. { "es-AR", "en-US" }
			-- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
			load_langs = { "en-US" }, -- en-US as default
			-- boolean : whether to load dictionaries on startup
			init_check = false,
			-- string : relative or absolute path to store dictionaries
			-- e.g. subfolder in the project root or the current working directory: ".ltex"
			-- e.g. shared files for all projects:  vim.fn.expand("~") .. "/.local/share/ltex"
			path = "", -- project root or current working directory
			-- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
			log_level = "none",
			-- table : configurations of the ltex language server.
			-- Only if you are calling the server from ltex_extra
			server_opts = nil,
		})
	end

	local has_neogit, neogit = pcall(require, "neogit")

	if has_neogit then
		keymap("n", "<leader>gg", "<cmd>Neogit<cr>", opts)
		keymap("n", "<leader>gl", "<cmd>Neogit log<cr>", opts)
	end

	local has_wk, wk = pcall(require, "which-key")
	if has_wk then
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		wk.setup()
	end

	if has_wk then
		wk.add({
			{ "<leader>n", group = "Neotree", remap = false },
		})
		wk.add({
			{ "<leader>t", group = "Toggle", remap = false },
			{ "<leader>te", "<cmd>NeoTree toggle<cr>", desc = "Neo Tree", remap = false },
			{ "<leader>ts", "<cmd>SymbolsOutline<cr>", desc = "Symbols", remap = false },
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal", remap = false },
			{ "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree", remap = false },
			{ "<leader>tz", "<cmd>ZenMode<cr>", remap = false },
		}, opts)
	end

	keymap("n", "<leader>En", "<cmd>cnext<cr>", opts)
	keymap("n", "<leader>Ep", "<cmd>cprev<cr>", opts)

	if has_wk then
		wk.add({
			{ "<leader>E", group = "Error", remap = false },
			{ "<leader>En", "<cmd>cnext<cr>", desc = "Next", remap = false },
			{ "<leader>Ep", "<cmd>cprev<cr>", desc = "Prev", remap = false },
		}, opts)
	end

	keymap("n", "<leader>bn", "<cmd>bn<cr>", opts)
	keymap("n", "<leader>bp", "<cmd>bp<cr>", opts)
	keymap("n", "<leader>bd", "<cmd>bd<cr>", opts)

	if has_wk then
		wk.add({
			{ "<leader>b", group = "Buffer", remap = false },
			{ "<leader>bd", "<cmd>bd<cr>", desc = "Buffer Delete", remap = false },
			{ "<leader>bn", "<cmd>bn<cr>", desc = "Buffer Next", remap = false },
			{ "<leader>bp", "<cmd>bp<cr>", desc = "Buffer Previous", remap = false },
			{ "<leader>bb", "<cmd>Neotree buffers<cr>", desc = "Buffer List", remap = false },
		}, opts)
	end

	local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree")

	if has_nvim_tree then
		nvim_tree.setup({
			sort_by = "case_sensitive",
			view = {
				width = 24,
			},
		})
	end

	local has_orgmode, orgmode = pcall(require, "orgmode")

	if has_orgmode then
		orgmode.setup({})
	end

	local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")

	local treesitter_list = {
		"http",
		"javascript",
		"typescript",
		"c",
		"lua",
		"rust",
		"go",
		"org",
		"markdown",
		"c_sharp",
		"org",
		"bash",
		"css",
		"html",
		"python",
		"solidity",
		"vue",
		"yaml",
		"org",
		"markdown",
		"markdown_inline",
	}

	if has_treesitter_configs then
		treesitter_configs.setup({
			-- A list of parser names, or "all"
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = treesitter_list,

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = { "org" },
			},
		})
	end

	local has_lspconfig, lspconfig = pcall(require, "lspconfig")

	if has_lspconfig then
		lspconfig.glslls.setup({})
		lspconfig.nil_ls.setup({})
		lspconfig.grammarly.setup({})
		lspconfig.ltex.setup({})
	end

	local has_lspzero, lspzero = pcall(require, "lsp-zero")
	local has_cmp, cmp = pcall(require, "cmp")
	local has_lspkind, lspkind = pcall(require, "lspkind")

	if has_cmp and has_lspkind then
		cmp.setup({
			formatting = {
				-- here is where the change happens
				fields = { "abbr", "kind", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end

	-- if has_cmp and has_lspzero then
	--     local cmp_select = { behavior = cmp.SelectBehavior.Select }
	--     local cmp_mappings = lspzero.defaults.cmp_mappings({
	--         ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	--         ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
	--         ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	--         ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
	--         ["<C-y>"] = cmp.mapping.confirm({ select = true }),
	--         ["<Ret>"] = cmp.mapping.confirm({ select = true }),
	--         ["<C-e>"] = cmp.mapping.abort(),
	--         ["<Esc>"] = cmp.mapping.abort(),
	--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
	--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	--         ["<C-Space>"] = cmp.mapping.complete(),
	--     })
	--
	--     lspzero.setup_nvim_cmp({
	--         mapping = cmp_mappings,
	--     })
	-- end

	if has_cmp then
		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})
	end

	local lsp_list = {
		"bashls",
		"clangd",
		"cmake",
		"cssls",
		"csharp_ls",
		"denols",
		"diagnosticls",
		"dockerls",
		"docker_compose_language_service",
		"emmet_ls",
		"eslint",
		"gopls",
		"grammarly",
		"html",
		"jsonls",
		"ltex",
		"lua_ls",
		"marksman",
		"omnisharp",
		"pylsp",
		"pyright",
		"rome",
		"rust_analyzer",
		"solidity",
		"sqlls",
		"stylelint_lsp",
		-- "tsserver",
		"vimls",
		"volar",
		"yamlls",
		"zls",
	}

	if has_lspzero then
		lspzero.preset("recommended")

		lspzero.ensure_installed(lsp_list)

		-- Fix Undefined global 'vim'
		lspzero.configure("lua-language-server", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		lspzero.set_preferences({
			suggest_lsp_servers = false,
		})

		lspzero.on_attach(function(client, bufnr)
			local lspzero_opts = { buffer = bufnr, remap = false }

			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {
				desc = "Signature",
				buffer = bufnr,
				remap = false,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr, remap = false })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration", buffer = bufnr, remap = false })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition", buffer = bufnr, remap = false })
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr, remap = false })
			vim.keymap.set(
				"n",
				"gl",
				vim.diagnostic.open_float,
				{ desc = "Diagnostics", buffer = bufnr, remap = false }
			)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = bufnr, remap = false })
			vim.keymap.set(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				{ desc = "Implementation", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"[d",
				vim.diagnostic.goto_next,
				{ desc = "Next Diagnostics", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"]d",
				vim.diagnostic.goto_prev,
				{ desc = "Prev Diagnostics", buffer = bufnr, remap = false }
			)

			vim.keymap.set(
				"n",
				"<leader>vd",
				vim.diagnostic.open_float,
				{ desc = "Diagnostics", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"<leader>vs",
				vim.lsp.buf.workspace_symbol,
				{ desc = "Workspace Symbol", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"<leader>va",
				vim.lsp.buf.code_action,
				{ desc = "Code Action", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"<leader>vr",
				vim.lsp.buf.references,
				{ desc = "References", buffer = bufnr, remap = false }
			)
			vim.keymap.set("n", "<leader>vR", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr, remap = false })
			vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, {
				desc = "Format",
				buffer = bufnr,
				remap = false,
			})

			if has_wk then
				wk.add({
					{ "<leader>v", buffer = 1, group = "Vim Lsp", remap = false },
				})
			end

			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol, {
				desc = "Symbols",
				buffer = bufnr,
				remap = false,
			})
			vim.keymap.set(
				"n",
				"<leader>ld",
				vim.diagnostic.open_float,
				{ desc = "Diagnostics", buffer = bufnr, remap = false }
			)
			vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, {
				desc = "Next Diagnostics",
				buffer = bufnr,
				remap = false,
			})
			vim.keymap.set(
				"n",
				"<leader>lk",
				vim.diagnostic.goto_prev,
				{ desc = "Prev Diagnostics", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"<leader>la",
				vim.lsp.buf.code_action,
				{ desc = "Code Action", buffer = bufnr, remap = false }
			)
			vim.keymap.set(
				"n",
				"<leader>lr",
				vim.lsp.buf.references,
				{ desc = "References", buffer = bufnr, remap = false }
			)
			vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr, remap = false })
			vim.keymap.set(
				"i",
				"<leader>lh",
				vim.lsp.buf.signature_help,
				{ desc = "Signature", buffer = bufnr, remap = false }
			)
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format", buffer = bufnr, remap = false })

			if has_wk then
				wk.add({
					{ "<leader>l", buffer = 1, group = "Lsp", remap = false },
				})
			end
		end)

		lspzero.setup()

		vim.diagnostic.config({
			virtual_text = true,
		})
	end

	local has_telescope, telescope = pcall(require, "telescope")

	if has_telescope then
		-- To get ui-select loaded and working with telescope, you need to call
		-- load_extension, somewhere after setup function:
		telescope.load_extension("ui-select")
		telescope.setup({
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})
	end

	local has_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")
	if has_telescope_builtin then
		vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>f", telescope_builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>st", telescope_builtin.live_grep, { desc = "Find Text" })
		vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "Find Text" })
		vim.keymap.set("n", "<leader>sb", telescope_builtin.buffers, { desc = "Find Buffer" })
		vim.keymap.set("n", "<leader>bb", telescope_builtin.buffers, { desc = "Find Buffer" })
		vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "Find Help" })
		vim.keymap.set("n", "<leader>sb", telescope_builtin.buffers, { desc = "Find Buffer" })
	end

	if has_wk then
		wk.add({
			{ "<leader>o", group = "Org", remap = false },
			{ "<leader>s", group = "Search", remap = false },
		}, opts)
	end

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	local has_null_ls, null_ls = pcall(require, "null-ls")
	if has_null_ls then
		null_ls.setup({
			-- you can reuse a shared lspconfig on_attach callback here
			sources = {
				-- Formatters
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.cbfmt,
				null_ls.builtins.formatting.csharpier,
				null_ls.builtins.formatting.forge_fmt,
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.markdownlint,
				null_ls.builtins.formatting.mdformat,
				null_ls.builtins.formatting.nixfmt,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.rustywind,
				null_ls.builtins.formatting.shellharden,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.stylelint,
				null_ls.builtins.formatting.yamlfmt,
				null_ls.builtins.diagnostics.glslc.with({
					extra_args = { "--target-env=opengl" }, -- use opengl instead of vulkan1.0
				}),
				-- diagnostics
				null_ls.builtins.diagnostics.gitlint,
				null_ls.builtins.diagnostics.markdownlint,
				null_ls.builtins.diagnostics.pylint,
				null_ls.builtins.diagnostics.solhint,
				null_ls.builtins.diagnostics.staticcheck,
				null_ls.builtins.diagnostics.statix,
				null_ls.builtins.diagnostics.stylelint,
				null_ls.builtins.diagnostics.write_good,
				null_ls.builtins.diagnostics.yamllint,
				null_ls.builtins.diagnostics.commitlint,
				-- Completions
				null_ls.builtins.completion.spell,
				null_ls.builtins.completion.tags,
				-- Hover
				null_ls.builtins.hover.dictionary,
				-- Code Actions
				null_ls.builtins.code_actions.refactoring,
				null_ls.builtins.code_actions.impl,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end

	local has_cspell, cspell = pcall(require, "cspell")
	if has_cspell and has_null_ls then
		null_ls.setup({
			sources = {
				cspell.diagnostics,
				cspell.code_actions,
			},
		})
	end
	-- This is your opts table
	require("telescope").setup({
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),

				-- pseudo code / specification for writing custom displays, like the one
				-- for "codeactions"
				-- specific_opts = {
				--   [kind] = {
				--     make_indexed = function(items) -> indexed_items, width,
				--     make_displayer = function(widths) -> displayer
				--     make_display = function(displayer) -> function(e)
				--     make_ordinal = function(e) -> string
				--   },
				--   -- for example to disable the custom builtin "codeactions" display
				--      do the following
				--   codeactions = false,
				-- }
			},
		},
	})
	local has_dap, dap = pcall(require, "dap")
	local has_dapui, dapui = pcall(require, "dapui")
	local has_dapwidgets, dapwidgets = pcall(require, "dap.ui.widgets")
	if has_dap then
		vim.keymap.set("n", "<leader>dd", dap.continue, { desc = "Debug: Start/Continue", remap = false })
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue", remap = false })
		vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into", remap = false })
		vim.keymap.set("n", "<F10>", dap.step_into, { desc = "Debug: Step Into", remap = false })
		vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over", remap = false })
		vim.keymap.set("n", "<F11>", dap.step_over, { desc = "Debug: Step Over", remap = false })
		vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out", remap = false })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out", remap = false })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint", remap = false })
		vim.keymap.set("n", "<F6>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint", remap = false })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input, "Breakpoint condition: ")
		end, { desc = "Debug: Set Breakpoint", remap = false })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Toggle Repl" })
		vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end
	if has_dap and has_dapui then
		vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug: Toggle Session" })
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle Session" })
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})
	end
	if has_dapwidgets then
		vim.keymap.set({ "n", "v" }, "<leader>dh", dapwidgets.hover, { desc = "Debug: Hover" })
		vim.keymap.set({ "n", "v" }, "<leader>dp", dapwidgets.preview, { desc = "Debug: Preview" })
		vim.keymap.set({ "n", "v" }, "<leader>df", function()
			dapuiwidget.centered_float(dapuiwidgets.frames)
		end, { desc = "Debug: Float" })
		vim.keymap.set({ "n", "v" }, "<leader>ds", function()
			dapuiwidget.centered_float(dapwidgets.scopes)
		end, { desc = "Debug: Scope" })
	end
	require("mason-nvim-dap").setup({
		automatic_installation = true,
		handlers = {},
		ensure_installed = {},
	})
	wk.add({
		{ "<leader>d", group = "Debug", remap = false },
	})
end
