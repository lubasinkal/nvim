-- UI & General
vim.g.have_nerd_font = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.scrolloff = 10 -- Increased: keeps cursor more centered
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.fillchars:append({ eob = " ", diff = "╱" })
vim.opt.inccommand = "split" -- Great for previewing substitutions

-- Performance & Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300 -- 200 is very fast; 300 is usually the "sweet spot" for chorded keys

-- Modern UI behavior
vim.opt.cmdheight = 0
vim.opt.splitkeep = "screen" -- Keeps text in place when opening splits
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shada = "!,'100,<50,s10,h" -- Limit search history/registers to keep startup fast

-- Navigation & Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.whichwrap:append("<>[]hl")
vim.opt.iskeyword:append("-") -- Treat dash-separated words as one unit (good for CSS/HTML)

-- Completion & Wildmenu
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.pumheight = 10
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- Conceal (Good for Obsidian/JSON/Markdown)
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

-- System Integration
vim.opt.clipboard = "unnamedplus"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Highlighting Fixes
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })

-- Autocmds
-- Auto-center on InsertEnter (Your preference)
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.cmd("norm! zz")
	end,
})
