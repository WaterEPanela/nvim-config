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

map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>go", function()
	local file = vim.api.nvim_buf_get_name(0)
	local lnum = vim.fn.line(".")
	local out = vim.system(
		{ "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--", file },
		{ cwd = vim.fs.dirname(file), text = true }
	):wait()
	-- porcelain: "<sha> <line in that commit> ..." plus "filename <path at that commit>"
	local sha, orig = (out.stdout or ""):match("^(%x+) (%d+)")
	local path = (out.stdout or ""):match("\nfilename ([^\n]+)")
	if not sha or sha:match("^0+$") then
		return vim.notify("Line isn't committed yet", vim.log.levels.WARN)
	end
	require("gitsigns").show(sha .. ":" .. path, { open = "tabnew" }, function()
		vim.schedule(function()
			pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(orig), 0 })
		end)
	end)
end, { desc = "Open file at the line's last commit (new tab)" })
map("n", "<leader>gs", function()
	local gs = require("gitsigns")
	if #(gs.get_hunks() or {}) > 0 then
		gs.stage_buffer()
	else
		gs.reset_buffer_index() -- nothing left to stage: unstage
	end
end, { desc = "Stage / unstage buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk() -- toggles: unstages an already-staged hunk
end, { desc = "Stage / unstage hunk" })

-- the open diff view's tab, so <leader>Dv can close it again
local diff_tab
vim.api.nvim_create_autocmd("User", {
	pattern = { "CodeDiffOpen", "CodeDiffClose" },
	callback = function(ev)
		if ev.match == "CodeDiffOpen" and ev.data.mode == "explorer" then
			diff_tab = ev.data.tabpage
		elseif ev.match == "CodeDiffClose" and ev.data.tabpage == diff_tab then
			diff_tab = nil
		end
	end,
})
map("n", "<leader>Dv", function()
	if diff_tab and vim.api.nvim_tabpage_is_valid(diff_tab) then
		vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(diff_tab)) -- codediff cleans up on TabClosed
	else
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>Dh", "<cmd>CodeDiff history %<cr>", { desc = "File history" })
map("n", "<leader>DH", "<cmd>CodeDiff history<cr>", { desc = "Repo history" })
