-- no-op for parsers already installed; missing ones build in the background
require("nvim-treesitter").install({
	"astro", "bash", "c", "cmake", "cpp", "css", "diff", "fish", "gitignore", "go",
	"graphql", "html", "http", "java", "javascript", "jsdoc", "json", "lua", "luadoc", "luap",
	"markdown", "markdown_inline", "printf", "python", "query", "regex", "rust", "scss", "sql", "svelte",
	"toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("waterpanela.treesitter", { clear = true }),
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then -- fails when no parser exists for this filetype
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
