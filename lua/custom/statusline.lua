-- Native Neovim statusline (no lualine)
-- A clean Lua-driven statusline inspired by your bubbles theme

-- Enable truecolor so hex GUI colors are used when terminal supports it
vim.o.termguicolors = true

local colors = {
	violet = "#d183e8",
	grey = "#3a3a3a",
	blue = "#80a0ff",
	cyan = "#79dac8",
	red = "#ff5189",
	mustard = "#f2c811",
	white = "#c6c6c6",
	black = "#0d0d0f",
}

-- Apply highlight groups (with cterm fallbacks)
local function apply_highlights()
	vim.api.nvim_set_hl(0, "StMode", { fg = colors.black, bg = colors.violet, ctermfg = 0, ctermbg = 5 })
	vim.api.nvim_set_hl(0, "StModeInsert", { fg = colors.black, bg = colors.blue, ctermfg = 0, ctermbg = 4 })
	vim.api.nvim_set_hl(0, "StModeVisual", { fg = colors.black, bg = colors.cyan, ctermfg = 0, ctermbg = 6 })
	vim.api.nvim_set_hl(0, "StModeReplace", { fg = colors.black, bg = colors.red, ctermfg = 0, ctermbg = 1 })
	vim.api.nvim_set_hl(0, "StModeCommand", { fg = colors.black, bg = colors.mustard, ctermfg = 0, ctermbg = 3 })
	vim.api.nvim_set_hl(0, "StMiddle", { fg = colors.white, bg = colors.black, ctermfg = 15, ctermbg = 0 })
	vim.api.nvim_set_hl(0, "StText", { fg = colors.white, bg = colors.black, ctermfg = 15, ctermbg = 0 })
end

-- Ensure highlights are reapplied after colorscheme changes (colorschemes often override custom highlights)
apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = apply_highlights,
})

-- Mode names
local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	[""] = "V-BLOCK",
	c = "COMMAND",
	R = "REPLACE",
}

-- Get LSP clients
local function lsp_names()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return "No LSP"
	end
	local names = {}
	for _, c in ipairs(clients) do
		table.insert(names, c.name)
	end
	return " " .. table.concat(names, ", ")
end

-- Build the native statusline
local function statusline()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = modes[mode] or mode

	local hl_mode = (mode == "i" and "%#StModeInsert#")
		or (mode == "v" or mode == "V" or mode == "") and "%#StModeVisual#"
		or (mode == "R" and "%#StModeReplace#")
		or (mode == "c" and "%#StModeCommand#")
		or "%#StMode#"

	return table.concat({
		hl_mode .. " " .. mode_name .. " ",
		"%#StMiddle#  " .. vim.fn.expand("%:t") .. "  ",
		"%#StText#",
		"%=", -- align right
		" " .. lsp_names() .. " ",
		" " .. vim.bo.filetype .. " ",
		" " .. vim.bo.fileencoding .. " ",
		" %p%% ",
		" %l:%c ",
	})
end

vim.o.statusline = "%!v:lua.statusline()"
_G.statusline = statusline
