vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }

require('mini.comment').setup()
require('mini.notify').setup {
  lsp_progress = { enable = false },
  window = {
    winblend = 100,
  },
}
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.snippets').setup()
require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}
require('mini.surround').setup {
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    replace = 'gsr',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    update_n_lines = 'gsn',
  },
  n_lines = 500,
}

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Tabline (buffers) with icons; mini.icons is set up in deps.lua
require('mini.tabline').setup()

vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Sessions: global-only, stored per working directory
require('mini.sessions').setup {
  directory = vim.fn.stdpath 'data' .. '/sessions/',
  file = '', -- no local session files
  force = { read = true, write = true, delete = true },
  verbose = { write = true, delete = true },
}
