return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
			hint = { enable = true, paramType = true },
			-- setup({...}) tables rarely list every field; overriding vim.* functions is intended
			diagnostics = { disable = { "missing-fields", "duplicate-set-field" } },
		},
	},
}
