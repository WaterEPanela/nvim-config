vim.loader.enable()

_G.waterpanela = require("waterpanela.utils")

require("waterpanela.config.options")
require("waterpanela.config.keymaps")
require("waterpanela.config.autocmds")
require("waterpanela.config.commands")
require("waterpanela.config.workarounds")

require("waterpanela.plugins")
