-- init.lua
vim.o.termguicolors = true
vim.g.have_nerd_font = true -- set true if terminal font supports icons
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3 -- global statusline (saves space if you use one statusline plugin)
vim.opt.showtabline = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.fillchars:append({ eob = " ", diff = "╱" }) -- clean buffer tail + prettier diffs
vim.opt.inccommand = "split"

-- Command height: modern Neovim lets you hide it
vim.opt.cmdheight = 0
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
vim.opt.smoothscroll = true
vim.opt.splitkeep = "screen"
vim.opt.virtualedit = "block"
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove({ "c", "r", "o", "t" }) -- don't auto-insert comments or auto-wrap text
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.whichwrap:append("<>[]hl")
vim.opt.iskeyword:append("-")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 10
vim.opt.conceallevel = 2 -- 2 = hide conceal chars (useful for JSON, markdown, LaTeX)
vim.opt.concealcursor = "nc"
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 200 -- reduced for faster response
vim.api.nvim_create_autocmd("InsertEnter", {
	command = "norm zz",
})
-- Additional modern improvements
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"
vim.opt.wildignorecase = true
