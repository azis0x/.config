-- This config is for NeoVim 0.12+

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.winborder = "rounded"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
vim.opt.completeopt = "fuzzy,menuone,noselect,popup"
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300
vim.opt.showtabline = 2
vim.opt.laststatus = 3

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.showmode = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "exclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "UTF-8"

for _, plugin in ipairs({
	"gzip",
	"tar",
	"tarPlugin",
	"zip",
	"zipPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"matchit",
	"logiPat",
	"rrhelper",
}) do
	vim.g["loaded_" .. plugin] = 1
end

local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
	vim.fn.mkdir(spell_dir, "p")
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 80, visual = true })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/spell/*.add",
	group = vim.api.nvim_create_augroup("SpellFile", { clear = true }),
	callback = function()
		vim.cmd("silent mkspell! %")
	end,
})

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})

require("vague").setup({
	transparent = true,
	italic = false,
})
vim.cmd([[ colorscheme vague ]])

local M = {
	n = "N",
	i = "I",
	v = "V",
	V = "VL",
	["\22"] = "VB",
	c = "C",
	R = "R",
	t = "T",
}

_G.statusline = function()
	local mode = M[vim.fn.mode()] or "U"
	local s = "%#StatusLineMode# " .. mode .. " %#StatusLine# %f%m%r"

	local head = vim.b.gitsigns_head
	if head and head ~= "" then
		s = s .. "%#StatusLineGit#  " .. head
	end

	local git = vim.b.gitsigns_status_dict
	if git then
		if git.added and git.added > 0 then
			s = s .. " %#StatusLineGitAdd#+" .. git.added
		end
		if git.changed and git.changed > 0 then
			s = s .. " %#StatusLineGitChange#~" .. git.changed
		end
		if git.removed and git.removed > 0 then
			s = s .. " %#StatusLineGitRemove#-" .. git.removed
		end
	end

	local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
	return s .. "%=%#StatusLine# %y " .. enc .. "[" .. vim.bo.fileformat .. "] %l:%c %#StatusLineMode# %p%% "
end

vim.o.statusline = "%!v:lua.statusline()"

local c = {
	bg = "#1c1c24",
	fg = "#cdcdcd",

	dark = "#252530",
	accent = "#aeaed1",
	soft = "#d7d7d7",
	warn = "#f3be7c",

	plus = "#7fa563",
	error = "#d8647e",
}

vim.api.nvim_set_hl(0, "StatusLine", {
	fg = c.fg,
	bg = c.bg,
})
vim.api.nvim_set_hl(0, "StatusLineMode", {
	fg = c.dark,
	bg = c.accent,
	bold = true,
})
vim.api.nvim_set_hl(0, "StatusLineGit", {
	fg = c.soft,
	bg = c.bg,
})
vim.api.nvim_set_hl(0, "StatusLineGitAdd", {
	fg = c.plus,
	bg = c.bg,
})
vim.api.nvim_set_hl(0, "StatusLineGitChange", {
	fg = c.warn,
	bg = c.bg,
})
vim.api.nvim_set_hl(0, "StatusLineGitRemove", {
	fg = c.error,
	bg = c.bg,
})

vim.api.nvim_set_hl(0, "TabLine", {
	fg = c.fg,
	bg = c.dark,
})
vim.api.nvim_set_hl(0, "TabLineSel", {
	fg = c.dark,
	bg = c.accent,
	bold = true,
})
vim.api.nvim_set_hl(0, "TabLineFill", {
	fg = c.fg,
	bg = c.bg,
})

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"permissions",
		"size",
		"mtime",
	},
	view_options = {
		show_hidden = true,
	},
})

vim.defer_fn(function()
	require("nvim-autopairs").setup()
	require("nvim-ts-autotag").setup()
end, 50)

vim.api.nvim_create_autocmd("InsertEnter", {
	group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true }),
	once = true,
	callback = function()
		require("blink.cmp").setup({
			keymap = { preset = "enter" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				documentation = {
					auto_show = false,
					window = { border = "rounded" },
				},
				accept = {
					auto_brackets = { enabled = true },
				},
			},
			signature = {
				-- enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = {
				sorts = {
					function(a, b)
						if a.client_name == b.client_name then
							return
						end
						return b.client_name == "emmet_ls"
					end,
					"score",
					"sort_text",
				},
			},
		})
	end,
})

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "💡",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

vim.defer_fn(function()
	vim.lsp.enable({
		"lua_ls",
		"ts_ls",
		"html",
		"cssls",
		"jsonls",
		"emmet_ls",
		"pug",
	})
end, 50)

require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
	"vim",
	"vimdoc",
	"lua",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"markdown",
	"markdown_inline",
	"bash",
	"query",
	"regex",
	"make",
	"sql",
	"yaml",
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", stop_after_first = true },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_after_save = { timeout_ms = 500 },
})

require("gitsigns").setup({
	current_line_blame = true,
	preview_config = {
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
})

if vim.fn.executable("rg") == 1 then
	function _G.RgFindFiles(cmdarg, _)
		local fnames = vim.fn.systemlist(
			'rg --files --hidden --color=never --glob="!.git" --glob="!node_modules/" --glob="!.cargo/"'
		)
		if #cmdarg == 0 then
			return fnames
		else
			return vim.fn.matchfuzzy(fnames, cmdarg)
		end
	end

	vim.o.findfunc = "v:lua.RgFindFiles"
end
local function is_cmdline_type_find()
	local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
	return cmdline_cmd == "find" or cmdline_cmd == "fin"
end
vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
	pattern = { "*" },
	group = vim.api.nvim_create_augroup("CmdlineAutocompletion", { clear = true }),
	callback = function(ev)
		local function should_enable_autocomplete()
			local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
			return is_cmdline_type_find() or cmdline_cmd == "help" or cmdline_cmd == "h"
		end
		if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
			vim.opt.wildmode = "noselect:lastused,full"
			vim.fn.wildtrigger()
		end
		if ev.event == "CmdlineLeave" then
			vim.opt.wildmode = "full"
		end
	end,
})

vim.keymap.set("n", "<leader>c", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = true })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<leader><ESC>", "<cmd>bdelete<cr>", { silent = true })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { silent = true })
vim.keymap.set("n", "<leader>f", ":find ")

vim.keymap.set("n", "<leader>V", "<cmd>e $MYVIMRC<cr>", { silent = true })
vim.keymap.set("n", "<leader>Z", "<cmd>e $ZDOTDIR/.zshrc<cr>", { silent = true })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>so", ":update<CR> :source %<CR>")

vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")
