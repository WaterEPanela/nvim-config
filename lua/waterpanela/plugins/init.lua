vim.pack.add({
	"https://github.com/rachartier/tiny-cmdline.nvim",
})

require("waterpanela.plugins.ui")
-- keymaps go last so every plugin is set up first
require("waterpanela.plugins.keymap")
