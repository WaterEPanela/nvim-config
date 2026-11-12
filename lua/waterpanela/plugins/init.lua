-- registered before vim.pack.add so it also sees changes made by that call
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate") -- parsers must match the plugin version
		end
	end,
})

vim.pack.add({
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/stevearc/oil.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("waterpanela.plugins.ui")
require("waterpanela.plugins.explorer")
require("waterpanela.plugins.treesitter")
-- keymaps go last so every plugin is set up first
require("waterpanela.plugins.keymap")
