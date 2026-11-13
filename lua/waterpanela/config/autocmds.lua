local group = vim.api.nvim_create_augroup("waterpanela", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = group,
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		vim.wo.cursorline = false
	end,
})

-- nvim-highlight-colors already paints colors; don't let the LSP paint them twice
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ev)
		vim.lsp.document_color.enable(false, { bufnr = ev.buf })
	end,
})
