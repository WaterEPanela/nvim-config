local map = vim.keymap.set

map({ "n", "x" }, "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
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
