-- UI & Layout
vim.g.have_nerd_font = true
vim.opt.signcolumn = 'yes'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.smoothscroll = true
vim.opt.sidescrolloff = 2
vim.opt.fillchars:append { eob = ' ' }
vim.o.winborder = 'rounded'

-- Files & Undo
vim.opt.swapfile = false
vim.opt.undofile = true

-- Indentation (shiftwidth = 0 inherits tabstop)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

-- Search & Display
vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '  ' }
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Completion Popup Menu
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40
vim.opt.pumheight = 10
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.wildmode = 'longest:full,full'

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Transparent background — survives any colorscheme switch.
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('TransparentBackground', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
})

vim.diagnostic.config {
  severity_sort = true,
  virtual_text = true,
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  float = { scope = 'cursor', focus = false },
  jump = { float = true },
}
