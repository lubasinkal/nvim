-- ===========
-- General
-- ===========
vim.g.have_nerd_font = true -- set true if terminal font supports icons

-- ===========
-- UI
-- ===========
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3 -- global statusline (saves space if you use one statusline plugin)
vim.opt.showtabline = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true -- helps orient your eye; toggle off if distracting
vim.opt.scrolloff = 5     -- reduced from 8 for better screen utilization
vim.opt.sidescrolloff = 5 -- reduced from 8 for better screen utilization
vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.fillchars:append { eob = ' ', diff = '╱' } -- clean buffer tail + prettier diffs
vim.opt.confirm = true
vim.opt.inccommand = 'split'
vim.opt.showmode = false -- redundant with modern statusline plugins

-- Command height: modern Neovim lets you hide it
vim.opt.cmdheight = 0

-- Improved transparency settings for better readability
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e1e' }) -- Slightly darker background for floating windows

-- ===========
-- Modern UI Enhancements
-- ===========
vim.opt.smoothscroll = true   -- smooth scrolling for modern terminals
vim.opt.splitkeep = 'screen'  -- keep screen content stable when splitting
vim.opt.virtualedit = 'block' -- allow cursor to move freely in visual block mode

-- ===========
-- Indentation
-- ===========
vim.opt.smartindent = true -- autoindent is redundant when smartindent is enabled
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove { 'c', 'r', 'o', 't' } -- don't auto-insert comments or auto-wrap text

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
-- Removed encoding and fileencoding as UTF-8 is default in modern Neovim
vim.opt.clipboard = 'unnamed' -- Better compatibility on Windows than 'unnamedplus'

-- ===========
-- Performance
-- ===========
vim.opt.updatetime = 250
vim.opt.timeoutlen = 200 -- reduced for faster response
vim.opt.redrawtime = 1500
vim.opt.ttimeoutlen = 10

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
vim.opt.foldenable = true                       -- enable folding by default

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

-- Additional modern improvements
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildoptions = 'pum'
vim.opt.wildignorecase = true
