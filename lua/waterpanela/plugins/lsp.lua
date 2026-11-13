require("mason").setup() -- also puts mason's bin dir on PATH so the servers below are found
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server", "vtsls", "eslint-lsp", "oxlint", "tailwindcss-language-server", "css-lsp",
		"rust-analyzer", "copilot-language-server",
		"prettier", "prettierd", "oxfmt", "stylua", "shfmt",
	},
	run_on_start = true,
	auto_update = false,
})

-- merged into every server's config; lets oil/snacks renames update imports
vim.lsp.config("*", {
	capabilities = { workspace = { fileOperations = { didRename = true, willRename = true } } },
})

-- configs come from nvim-lspconfig's lsp/ dir
vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })

-- one icon set for gutter signs and inline prefixes (mini.icons has none for diagnostics)
local S = vim.diagnostic.severity
local icons = { [S.ERROR] = "\u{f015a}", [S.WARN] = "\u{f002a}", [S.INFO] = "\u{f02fd}", [S.HINT] = "\u{f0336}" }
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		source = "if_many",
		prefix = function(d)
			return icons[d.severity]
		end,
	},
	signs = { text = icons },
})
