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
