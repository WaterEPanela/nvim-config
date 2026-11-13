-- kind icon and its color both come from mini.icons, the shared icon set
local function kind_hl(ctx)
	local _, hl = MiniIcons.get("lsp", ctx.kind)
	return hl
end

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		ghost_text = { enabled = false }, -- Copilot shows its own inline suggestions
		menu = {
			draw = {
				treesitter = { "lsp" },
				components = {
					kind_icon = {
						text = function(ctx)
							return MiniIcons.get("lsp", ctx.kind) .. ctx.icon_gap
						end,
						highlight = kind_hl,
					},
					kind = { highlight = kind_hl },
				},
			},
		},
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = { selection = { preselect = false } },
		},
	},
})

require("mini.pairs").setup({ modes = { command = true } }) -- default is insert only
