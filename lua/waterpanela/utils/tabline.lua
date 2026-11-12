local M = {}

-- Nerd Font U+E0BA / U+E0B8 (lower-right / lower-left triangles): both edges slant outward going down
local LEFT, RIGHT = "\238\130\186", "\238\130\184"

local function label(tab)
	local win = vim.api.nvim_tabpage_get_win(tab)
	local buf = vim.api.nvim_win_get_buf(win)
	local path = vim.api.nvim_buf_get_name(buf)
	local text
	if vim.bo[buf].buftype == "terminal" then
		text = "[Terminal]"
	elseif vim.bo[buf].filetype == "oil" then
		local dir = vim.fn.fnamemodify(path:gsub("^oil://", ""), ":~"):gsub("(.)/$", "%1")
		local n = vim.fn.strchars(dir)
		text = n > 20 and ("..." .. vim.fn.strcharpart(dir, n - 17)) or dir
	elseif path == "" then
		text = "[No Name]"
	else
		local name = vim.fn.fnamemodify(path, ":t")
		if vim.fn.strchars(name) > 20 then
			name = vim.fn.strcharpart(name, 0, 17) .. "..."
		end
		local icon = _G.MiniIcons and MiniIcons.get("file", path)
		text = icon and (icon .. " " .. name) or name
	end
	if vim.bo[buf].modified then
		text = "[+] " .. text
	end
	return (text:gsub("%%", "%%%%")) -- a literal % would start a statusline item
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local out = {}
	for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local hl = tab == current and "TabLineSel" or "TabLine"
		out[#out + 1] = ("%%%dT%%#%sSep#%s%%#%s#   %s   %%#%sSep#%s"):format(i, hl, LEFT, hl, label(tab), hl, RIGHT)
	end
	return table.concat(out) .. "%#TabLineFill#%T"
end

return M
