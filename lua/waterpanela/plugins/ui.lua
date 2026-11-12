vim.cmd.colorscheme("waterpanela") -- colors/waterpanela.lua

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons() -- plugins asking for nvim-web-devicons get mini.icons

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})
