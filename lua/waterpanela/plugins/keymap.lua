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
