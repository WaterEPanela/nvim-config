vim.pack.add({
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
})

require("waterpanela.plugins.ui")
-- keymaps go last so every plugin is set up first
require("waterpanela.plugins.keymap")
