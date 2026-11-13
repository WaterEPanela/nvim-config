local map = vim.keymap.set

map({ "n", "x" }, "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>C", '"_c', { desc = "Change without copying" })
map("x", "<leader>p", '"_dP', { desc = "Paste over selection, keep yank" })

map("n", "te", "<cmd>tabedit<cr>", { desc = "New tab" })
map("n", "<Tab>", "gt", { desc = "Next tab" })
map("n", "<S-Tab>", "gT", { desc = "Previous tab" })
map("n", "<S-l>", "gt", { desc = "Next tab" })
map("n", "<S-h>", "gT", { desc = "Previous tab" })

map("n", "ss", "<cmd>split<cr>", { desc = "Split below" })
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Split right" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<C-S-h>", "<C-w><", { desc = "Narrower window" })
map("n", "<C-S-l>", "<C-w>>", { desc = "Wider window" })
map("n", "<C-S-k>", "<C-w>+", { desc = "Taller window" })
map("n", "<C-S-j>", "<C-w>-", { desc = "Shorter window" })

map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear search highlight" })

map("n", "bd", "<cmd>confirm bdelete<cr>", { desc = "Close buffer" })
map("n", "bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.bo[buf].buflisted then
			pcall(vim.cmd.bdelete, { buf, mods = { confirm = true } }) -- Cancel on one buffer keeps it open and moves on
		end
	end
end, { desc = "Close other buffers" })

-- "path#L<line>" in the clipboard, for pointing an agent at the exact line
local function copy_path(modifier)
	local path = vim.fn.expand("%" .. modifier)
	if path == "" then
		return vim.notify("Buffer has no file", vim.log.levels.WARN)
	end
	local text = ("%s#L%d"):format(path, vim.fn.line("."))
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. text)
end
map("n", "<leader>yf", function()
	copy_path(":.")
end, { desc = "Copy relative path#line" })
map("n", "<leader>yp", function()
	copy_path(":p")
end, { desc = "Copy absolute path#line" })

-- Inkdrop-style code-block attributes, with the short language names it expects
local short_lang = { typescriptreact = "tsx", javascriptreact = "jsx", typescript = "ts", javascript = "js" }
map("x", "<leader>cc", function()
	local first, last = vim.fn.line("v"), vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	local ft = vim.bo.filetype
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
	local header = ('```%s filename="%s" line=%d'):format(short_lang[ft] or ft, vim.fn.expand("%:."), first)
	vim.fn.setreg("+", header .. "\n" .. table.concat(lines, "\n") .. "\n```\n")
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { desc = "Copy as Markdown code block" })

map("n", "<leader>j", function()
	local root = vim.fs.root(0, "package.json")
	if not root then
		return vim.notify("No package.json found", vim.log.levels.WARN)
	end
	local buf = vim.fn.bufadd(root .. "/package.json")
	vim.fn.bufload(buf)
	local w, h = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor", width = w, height = h,
		col = math.floor((vim.o.columns - w) / 2), row = math.floor((vim.o.lines - h) / 2),
	})
	local keys = { "q", "<Esc>" }
	for _, key in ipairs(keys) do
		map("n", key, function()
			vim.api.nvim_win_close(win, false)
		end, { buffer = buf, nowait = true, desc = "Close package.json float" })
	end
	-- the buffer outlives the float, so take the close keys back off it
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			for _, key in ipairs(keys) do
				pcall(vim.keymap.del, "n", key, { buffer = buf })
			end
		end,
	})
end, { desc = "Open package.json (float)" })
