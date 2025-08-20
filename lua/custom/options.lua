-- ===========
-- General
-- ===========
vim.g.have_nerd_font = true -- set true if terminal font supports icons

-- UI
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3 -- global statusline (saves space if you use one statusline plugin)
vim.opt.showtabline = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true -- helps orient your eye; toggle off if distracting
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.fillchars:append { eob = ' ', diff = '╱' } -- clean buffer tail + prettier diffs
vim.opt.confirm = true
vim.opt.inccommand = 'split'

-- Command height: modern Neovim lets you hide it
vim.opt.cmdheight = 0

-- Transparency (optional)
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.opt.pumblend = 10
vim.opt.winblend = 10

-- ===========
-- Indentation
-- ===========
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- don’t auto-insert comments

-- ===========
-- Search
-- ===========
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.whichwrap:append '<>[]hl'
vim.opt.iskeyword:append '-'

-- ===========
-- Splits
-- ===========
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ===========
-- Files & Undo
-- ===========
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
local undodir = vim.fn.stdpath 'state' .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir

-- ===========
-- Completion
-- ===========
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.pumheight = 10
vim.opt.shortmess:append 'c'

-- ===========
-- Conceal
-- ===========
vim.opt.conceallevel = 2 -- 2 = hide conceal chars (useful for JSON, markdown, LaTeX)
vim.opt.concealcursor = 'nc'

-- ===========
-- Encoding & Clipboard
-- ===========
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.clipboard = 'unnamedplus'

-- ===========
-- Performance
-- ===========
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400 -- balance between speed and comfort

-- ===========
-- Invisible chars
-- ===========
vim.opt.list = true
vim.opt.listchars = {
  tab = '»·',
  trail = '·',
  nbsp = '␣',
  extends = '⟩',
  precedes = '⟨',
}

-- ===========
-- Folding
-- ===========
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' -- way more accurate than syntax
vim.opt.foldlevelstart = 99

-- ===========
-- Filetypes
-- ===========
vim.g.markdown_fenced_languages = {
  'html',
  'javascript',
  'javascriptreact',
  'typescript',
  'json',
  'css',
  'scss',
  'lua',
  'vim',
  'bash',
  'ts=typescript',
  'js=javascript',
}

-- ===========
-- Autocommands
-- ===========
vim.api.nvim_create_autocmd('InsertEnter', {
  command = 'norm zz',
})
