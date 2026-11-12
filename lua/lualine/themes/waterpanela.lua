-- picked up by lualine's theme = "auto" because it matches colors_name; colors come from the scheme's groups
local function fg(name)
	return string.format("#%06x", vim.api.nvim_get_hl(0, { name = name, link = false }).fg)
end

local dark, light = "#11131c", "#f2f4ff"
local b = { fg = fg("Normal"), bg = "#1b2033" }
local c = { fg = fg("TabLine"), bg = "NONE" } -- transparent middle, like the buffer

local function mode(bg, text)
	return { a = { fg = text, bg = bg, gui = "bold" }, b = b, c = c }
end

return {
	normal = mode("#5a4fcf", light), -- same violet as the active tab
	insert = mode(fg("String"), dark),
	visual = mode(fg("Type"), dark),
	replace = mode(fg("@function.builtin"), dark),
	command = mode(fg("Number"), dark),
	terminal = mode(fg("Operator"), dark),
	inactive = { a = b, b = b, c = c },
}
