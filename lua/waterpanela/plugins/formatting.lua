-- first available wins; oxfmt counts as available only with a config (see condition below)
local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
	formatters_by_ft = {
		javascript = web, typescript = web, javascriptreact = web, typescriptreact = web,
		json = web, css = web, scss = web, less = web, html = web,
		markdown = web, mdx = web, yaml = web,
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
	},
	formatters = {
		oxfmt = {
			-- conform's oxfmt cwd is the dir holding .oxfmtrc.json / vite.config.ts etc., nil without one,
			-- so prettier projects keep prettier
			condition = function(self, ctx)
				return self.cwd(self, ctx) ~= nil
			end,
		},
	},
	format_on_save = function(buf)
		if vim.b[buf].disable_autoformat then -- set by :ToggleFormatter
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
