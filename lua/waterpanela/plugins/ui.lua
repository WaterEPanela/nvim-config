-- waterpanela (colors/waterpanela.lua, copy in backup/waterpanela/) is parked while we work
require("kanagawa").setup({
	transparent = true, -- kitty's background shows through
	overrides = function(colors)
		local ui = colors.theme.ui
		-- the tabline's slanted edges take the fg of the tab they border
		return { TabLineSep = { fg = ui.bg_m3 }, TabLineSelSep = { fg = ui.bg_p1 } }
	end,
})
vim.cmd.colorscheme("kanagawa-dragon")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons() -- plugins asking for nvim-web-devicons get mini.icons

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})

local root_markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		component_separators = "",
		section_separators = { left = "\238\130\184", right = "\238\130\186" }, -- same slants as the tabline
		refresh = {
			events = {
				"WinEnter", "BufEnter", "BufWritePost", "SessionLoadPost", "FileChangedShellPost",
				"VimResized", "Filetype", "ModeChanged", "CursorMoved", "CursorMovedI",
				"RecordingEnter", "RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			function()
				local root = vim.fs.root(0, root_markers)
				if not root or root == vim.fn.getcwd() then
					return ""
				end
				return "󱉭 " .. vim.fs.basename(root)
			end,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, symbols = { modified = "[+]", readonly = "", unnamed = "[No Name]" } },
		},
		lualine_x = {
			function()
				local reg = vim.fn.reg_recording()
				return reg ~= "" and ("recording @" .. reg) or ""
			end,
			"diagnostics",
			"diff",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- the statusline is global, so each split labels its own file
require("incline").setup({
	hide = { cursorline = true },
	render = function(props)
		local path = vim.api.nvim_buf_get_name(props.buf)
		local name = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
		local icon, icon_hl = MiniIcons.get("file", path)
		return {
			path ~= "" and { icon, " ", group = icon_hl } or "",
			name,
			vim.bo[props.buf].modified and " [+]" or "",
		}
	end,
})

require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false }, -- scrolling stays instant
	picker = {
		enabled = true,
		sources = {
			-- Ctrl+n sidebar; snacks' explorer module stays off so oil keeps replacing netrw
			explorer = {
				hidden = true,
				win = {
					list = {
						keys = {
							["d"] = false,
							["dd"] = "explorer_del",
							["r"] = "explorer_rename", -- the prompt edits the path from cwd, so it moves too
							["c"] = "explorer_add",
							["<C-n>"] = "close", -- same key that opened it
						},
					},
				},
			},
		},
	},
})

require("todo-comments").setup() -- highlighting only; its search commands would need plenary.nvim

-- defaults paint hex, rgb, hsl, ANSI and CSS variable colors as backgrounds
require("nvim-highlight-colors").setup({ enable_tailwind = false })
