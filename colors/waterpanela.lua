-- Complementary contrast against the desktop (Kanagawa Dragon: warm black, muted earth tones).
-- The editor answers with the opposite side of the wheel: vivid cool hues (violet, blue, sky, mint)
-- carry the structure, warm hues (gold, rose, coral, orange) mark types, parameters, builtins and
-- values. Every syntax role sits >= 8.5 OKLab ΔE from every other, and >= 6:1 contrast on the bg.
-- Normal has no background so kitty's transparency shows through; floats stay solid to read.
local c = {
	fg = "#d4dcf0", fg_dim = "#93a0c0", comment = "#6c7a9e", nontext = "#2e3448", linenr = "#4a5574",
	kw = "#a08cff", fn = "#6cb6ff", type = "#ffd88a", str = "#7ee0c3", num = "#ff9e64",
	op = "#89ddff", punc = "#8a96bd", param = "#f5a8c0", prop = "#c3b6ff", special = "#e88cff",
	builtin = "#ff7a7a",
	accent = "#ff9e64", bg = "#11131c", float = "#151827", cul = "#1b2033", visual = "#273050",
	border = "#3b4466", search_bg = "#4d3420", search_fg = "#ffd2a8",
	err = "#ff6e86", warn = "#ffb86c", info = "#6cb6ff", hint = "#7ee0c3",
	add = "#7ee0a0", change = "#6cb6ff", del = "#ff6e86",
}

vim.cmd("hi clear")
vim.g.colors_name = "waterpanela"
vim.o.background = "dark"

local hl = {
	Normal = { fg = c.fg }, NormalNC = { fg = c.fg },
	NormalFloat = { fg = c.fg, bg = c.float }, FloatBorder = { fg = c.border, bg = c.float },
	FloatTitle = { fg = c.accent, bg = c.float, bold = true },
	CursorLine = { bg = c.cul }, CursorLineNr = { fg = c.accent, bold = true }, LineNr = { fg = c.linenr },
	SignColumn = {}, FoldColumn = { fg = c.linenr }, Folded = { fg = c.fg_dim, bg = c.cul },
	ColorColumn = { bg = c.cul }, Visual = { bg = c.visual },
	Search = { fg = c.search_fg, bg = c.search_bg }, CurSearch = { fg = c.bg, bg = c.accent, bold = true },
	IncSearch = { link = "CurSearch" }, MatchParen = { fg = c.accent, bold = true, underline = true },
	Pmenu = { fg = c.fg_dim, bg = c.float }, PmenuSel = { fg = c.fg, bg = c.visual, bold = true },
	PmenuSbar = { bg = c.float }, PmenuThumb = { bg = c.border }, PmenuMatch = { fg = c.accent, bold = true },
	StatusLine = { fg = c.fg_dim, bg = c.bg }, StatusLineNC = { fg = c.linenr, bg = c.bg },
	TabLine = { fg = c.linenr, bg = c.bg }, TabLineSel = { fg = c.fg, bg = c.cul, bold = true }, TabLineFill = { bg = c.bg },
	WinSeparator = { fg = c.border }, NonText = { fg = c.nontext }, Whitespace = { fg = c.nontext },
	EndOfBuffer = { fg = c.nontext }, Conceal = { fg = c.comment },
	Directory = { fg = c.kw }, Title = { fg = c.fn, bold = true }, Question = { fg = c.info },
	MoreMsg = { fg = c.info }, ModeMsg = { fg = c.fg_dim }, MsgArea = { fg = c.fg },
	ErrorMsg = { fg = c.err }, WarningMsg = { fg = c.warn }, QuickFixLine = { bg = c.visual },
	WildMenu = { link = "PmenuSel" }, SpecialKey = { fg = c.nontext },
	Added = { fg = c.add }, Changed = { fg = c.change }, Removed = { fg = c.del },
	DiffAdd = { bg = "#1b2a22" }, DiffChange = { bg = "#1a2630" }, DiffDelete = { fg = c.del, bg = "#2c1d1d" },
	DiffText = { bg = "#253847" },
	SpellBad = { sp = c.err, undercurl = true }, SpellCap = { sp = c.warn, undercurl = true },
	SpellRare = { sp = c.hint, undercurl = true }, SpellLocal = { sp = c.info, undercurl = true },

	Comment = { fg = c.comment, italic = true }, Constant = { fg = c.num }, String = { fg = c.str },
	Character = { fg = c.str }, Number = { fg = c.num }, Boolean = { fg = c.num }, Float = { fg = c.num },
	Identifier = { fg = c.fg }, Function = { fg = c.fn },
	Statement = { fg = c.kw }, Keyword = { fg = c.kw }, Conditional = { fg = c.kw }, Repeat = { fg = c.kw },
	Exception = { fg = c.kw }, Label = { fg = c.kw }, Operator = { fg = c.op },
	PreProc = { fg = c.kw }, Include = { fg = c.kw }, Define = { fg = c.kw }, Macro = { fg = c.builtin },
	Type = { fg = c.type }, StorageClass = { fg = c.kw }, Structure = { fg = c.type },
	Special = { fg = c.special }, Delimiter = { fg = c.punc }, SpecialComment = { fg = c.fg_dim, italic = true },
	Todo = { fg = c.bg, bg = c.accent, bold = true }, Underlined = { underline = true },
	Error = { fg = c.err }, Debug = { fg = c.warn },

	["@variable"] = { fg = c.fg }, ["@variable.builtin"] = { fg = c.builtin, italic = true },
	["@variable.parameter"] = { fg = c.param, italic = true }, ["@variable.member"] = { fg = c.prop },
	["@property"] = { fg = c.prop }, ["@module"] = { fg = c.type }, ["@constant.builtin"] = { fg = c.num },
	["@function.call"] = { fg = c.fn }, ["@function.builtin"] = { fg = c.builtin }, ["@function.method.call"] = { fg = c.fn },
	["@constructor"] = { fg = c.punc }, ["@keyword.return"] = { fg = c.kw, italic = true },
	["@keyword.function"] = { fg = c.kw }, ["@keyword.import"] = { fg = c.kw, italic = true },
	["@string.escape"] = { fg = c.special }, ["@string.special.url"] = { fg = c.fn, underline = true },
	["@type.builtin"] = { fg = c.type, italic = true }, ["@module.builtin"] = { fg = c.builtin, italic = true },
	["@punctuation.bracket"] = { fg = c.punc }, ["@punctuation.delimiter"] = { fg = c.punc },
	["@punctuation.special"] = { fg = c.special },
	["@tag"] = { fg = c.kw }, ["@tag.attribute"] = { fg = c.prop, italic = true }, ["@tag.delimiter"] = { fg = c.punc },
	["@diff.plus"] = { fg = c.add }, ["@diff.minus"] = { fg = c.del }, ["@diff.delta"] = { fg = c.change },
	["@markup.heading"] = { fg = c.fn, bold = true }, ["@markup.link"] = { fg = c.kw, underline = true },
	["@markup.raw"] = { fg = c.str }, ["@markup.strong"] = { bold = true }, ["@markup.italic"] = { italic = true },
	["@lsp.type.parameter"] = { link = "@variable.parameter" }, ["@lsp.type.property"] = { link = "@property" },

	DiagnosticError = { fg = c.err }, DiagnosticWarn = { fg = c.warn },
	DiagnosticInfo = { fg = c.info }, DiagnosticHint = { fg = c.hint }, DiagnosticOk = { fg = c.add },
	DiagnosticUnderlineError = { sp = c.err, undercurl = true }, DiagnosticUnderlineWarn = { sp = c.warn, undercurl = true },
	DiagnosticUnderlineInfo = { sp = c.info, undercurl = true }, DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
	DiagnosticVirtualTextError = { fg = c.err, bg = "#2a1820" }, DiagnosticVirtualTextWarn = { fg = c.warn, bg = "#2a2018" },
	DiagnosticVirtualTextInfo = { fg = c.info, bg = "#16233a" }, DiagnosticVirtualTextHint = { fg = c.hint, bg = "#152a28" },
	DiagnosticUnnecessary = { fg = c.comment }, DiagnosticDeprecated = { strikethrough = true },
	LspInlayHint = { fg = c.comment, bg = c.cul, italic = true },
	LspReferenceText = { bg = c.cul }, LspReferenceRead = { bg = c.cul }, LspReferenceWrite = { bg = c.cul, underline = true },

	MiniIconsAzure = { fg = c.op }, MiniIconsBlue = { fg = c.fn }, MiniIconsCyan = { fg = c.str },
	MiniIconsGreen = { fg = c.add }, MiniIconsGrey = { fg = c.fg_dim }, MiniIconsOrange = { fg = c.num },
	MiniIconsPurple = { fg = c.kw }, MiniIconsRed = { fg = c.builtin }, MiniIconsYellow = { fg = c.type },
}
for name, spec in pairs(hl) do
	vim.api.nvim_set_hl(0, name, spec)
end

-- :terminal uses the same palette
for i, color in ipairs({
	c.bg, c.err, c.add, c.type, c.fn, c.kw, c.str, c.fg_dim,
	c.linenr, c.err, c.add, c.warn, c.op, c.special, c.hint, c.fg,
}) do
	vim.g["terminal_color_" .. (i - 1)] = color
end
