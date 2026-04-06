-- UI & General
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.scrolloff = 10 -- Increased: keeps cursor more centered
vim.opt.smoothscroll = true
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.fillchars:append { eob = ' ', diff = '╱' }
vim.opt.inccommand = 'split' -- Great for previewing substitutions
vim.o.winborder = 'rounded'
-- Performance & Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 200 -- faster CursorHold
vim.opt.timeoutlen = 300 -- faster which-key

-- vim.opt.cmdheight = 0
vim.opt.splitkeep = 'screen' -- Keeps text in place when opening splits
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove { 'c', 'r', 'o' }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shada = "!,'100,<50,s10,h" -- Limit search history/registers to keep startup fast

-- Navigation & Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.whichwrap:append '<>[]hl'
vim.opt.iskeyword:append '-' -- Treat dash-separated words as one unit (good for CSS/HTML)

-- Completion & Wildmenu
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40
vim.o.completeopt = 'menu,menuone,noselect,nearest'
vim.opt.pumheight = 10
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildoptions = 'pum'

-- Conceal (Good for Obsidian/JSON/Markdown)
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

-- System Integration
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Highlighting Fixes
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e1e' })

-- Autocmds
-- Auto-center on InsertEnter (Your preference)
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.cmd 'norm! zz'
  end,
})
-- Automatic window resizing
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd 'redraw!'
  end,
})
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

-- Vertical Help Page
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'wincmd L',
})

-- enable cursorline only in the active/current buffer/window and disable it when you leave
vim.api.nvim_create_augroup('CursorLineActive', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
  group = 'CursorLineActive',
  callback = function()
    vim.wo.cursorline = true
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = 'CursorLineActive',
  callback = function()
    vim.wo.cursorline = false
  end,
})

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
} -- Diagnonstic floating window on cursorhold
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    if next(vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })) then
      vim.diagnostic.open_float(nil, { focusable = false, border = 'rounded' })
    end
  end,
})
