local map = vim.keymap.set

map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

map("n", "<leader><leader>", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })
map("n", "sg", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "Buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer (float)" })
map("n", "<C-n>", function()
	local open = Snacks.picker.get({ source = "explorer" })[1]
	if open then
		open:close()
	else
		Snacks.picker.explorer()
	end
end, { desc = "Toggle file tree sidebar" })

-- vtsls' "go to source definition" skips the .d.ts and lands in the real code
local function source_definition(client)
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, result)
		if err or not result or #result == 0 then
			return vim.notify("No source definition found", vim.log.levels.WARN)
		end
		if #result == 1 then
			return vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
		end
		vim.fn.setqflist({}, " ", { title = "Source definitions", items = vim.lsp.util.locations_to_items(result, client.offset_encoding) })
		Snacks.picker.qflist()
	end)
end

map("n", "<leader>f", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format" })
map("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename file (updates imports)" })
map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })

-- buffer-local, so these only exist where a server is attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("waterpanela.lsp_keymaps", { clear = true }),
	callback = function(ev)
		local function bmap(mode, lhs, rhs, desc, opts)
			map(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, opts or {}))
		end
		bmap("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
		bmap("n", "gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration")
		bmap("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
		-- nowait: don't pause for Neovim's default grr/gra/grn/...
		bmap("n", "gr", function() Snacks.picker.lsp_references() end, "References", { nowait = true })
		bmap("n", "gI", function()
			local vtsls = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
			if vtsls then
				source_definition(vtsls)
			else
				Snacks.picker.lsp_implementations()
			end
		end, "Go to source definition / implementation")
		bmap("n", ";c", function() Snacks.picker.lsp_incoming_calls() end, "Incoming calls")
		bmap("n", "K", function() vim.lsp.buf.hover() end, "Hover")
		bmap("n", "gK", function() vim.lsp.buf.signature_help() end, "Signature help")
		bmap("i", "<C-k>", function() vim.lsp.buf.signature_help() end, "Signature help")
		bmap("n", "<C-j>", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
		bmap({ "n", "x" }, "<leader>ca", function() vim.lsp.buf.code_action() end, "Code action")
		bmap("n", "<leader>cr", function() vim.lsp.buf.rename() end, "Rename symbol")
	end,
})
