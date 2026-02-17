-- Native Neovim statusline with Diagnostics, Git, and simple LSP client names
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

-- 1. Highlights
local function apply_highlights()
	vim.api.nvim_set_hl(0, "StMode", { fg = colors.black, bg = colors.violet })
	vim.api.nvim_set_hl(0, "StModeInsert", { fg = colors.black, bg = colors.blue })
	vim.api.nvim_set_hl(0, "StModeVisual", { fg = colors.black, bg = colors.cyan })
	vim.api.nvim_set_hl(0, "StModeReplace", { fg = colors.black, bg = colors.red })
	vim.api.nvim_set_hl(0, "StModeCommand", { fg = colors.black, bg = colors.mustard })
	vim.api.nvim_set_hl(0, "StMiddle", { fg = colors.white, bg = colors.black })
	vim.api.nvim_set_hl(0, "StText", { fg = colors.white, bg = colors.black })

	-- Diagnostic Highlights
	vim.api.nvim_set_hl(0, "StErr", { fg = colors.red, bg = colors.black })
	vim.api.nvim_set_hl(0, "StWarn", { fg = colors.mustard, bg = colors.black })
	vim.api.nvim_set_hl(0, "StHint", { fg = colors.cyan, bg = colors.black })
	vim.api.nvim_set_hl(0, "StInfo", { fg = colors.blue, bg = colors.black })

	-- Git Highlight
	vim.api.nvim_set_hl(0, "StGit", { fg = colors.violet, bg = colors.black, bold = true })
end

apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_highlights })

-- 2. Diagnostics
local function get_diagnostics()
	local res = {}
	local levels = {
		errors = vim.diagnostic.severity.ERROR,
		warnings = vim.diagnostic.severity.WARN,
		hints = vim.diagnostic.severity.HINT,
		info = vim.diagnostic.severity.INFO,
	}

	local err = #vim.diagnostic.get(0, { severity = levels.errors })
	local warn = #vim.diagnostic.get(0, { severity = levels.warnings })
	local hint = #vim.diagnostic.get(0, { severity = levels.hints })
	local info = #vim.diagnostic.get(0, { severity = levels.info })

	if err > 0 then
		table.insert(res, "%#StErr#󰅚 " .. err)
	end
	if warn > 0 then
		table.insert(res, "%#StWarn#󰀪 " .. warn)
	end
	if hint > 0 then
		table.insert(res, "%#StHint#󰌶 " .. hint)
	end
	if info > 0 then
		table.insert(res, "%#StInfo#󰋽 " .. info)
	end

	return table.concat(res, " ")
end

-- 3. Git Branch (cached & prefers gitsigns if available)
local function get_git_branch()
	if vim.b.gitsigns_head then
		return "%#StGit#  " .. vim.b.gitsigns_head .. " "
	end

	-- Fallback manual check (cached 5 seconds)
	if vim.b.last_git_check == nil or vim.uv.now() - vim.b.last_git_check > 5000 then
		local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n$", "")
		if vim.v.shell_error == 0 and branch ~= "" then
			vim.b.git_branch = "%#StGit#  " .. branch .. " "
		else
			vim.b.git_branch = ""
		end
		vim.b.last_git_check = vim.uv.now()
	end

	return vim.b.git_branch or ""
end

-- 4. Simple LSP status – only shows attached client names
local function get_lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return "No LSP"
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return " " .. table.concat(names, ", ")
end

-- 5. Statusline
local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	[""] = "V-BLOCK",
	c = "COMMAND",
	R = "REPLACE",
}

_G.statusline = function()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = modes[mode] or mode:upper()

	local mode_hl = (mode == "i") and "%#StModeInsert#"
		or (mode == "v" or mode == "V" or mode == "") and "%#StModeVisual#"
		or (mode == "R") and "%#StModeReplace#"
		or (mode == "c") and "%#StModeCommand#"
		or "%#StMode#"

	return table.concat({
		mode_hl,
		" ",
		mode_name,
		" ",
		get_git_branch(),
		get_diagnostics(),
		" ",
		"%#StMiddle#",
		" ",
		vim.fn.expand("%:t"),
		" ",
		"%#StText#",
		"%=", -- right align
		" ",
		get_lsp_status(),
		"  ",
		vim.bo.filetype,
		"  %p%%  %l:%c ",
	})
end

vim.o.statusline = "%!v:lua.statusline()"
