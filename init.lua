-- Load essential configs early (keymaps, options)
require 'custom.keymaps'
require 'custom.options'

-- Defer statusline until first buffer (saves ~5-10ms)
vim.api.nvim_create_autocmd({ 'BufEnter', 'UIEnter' }, {
  once = true,
  callback = function()
    require 'custom.statusline'
  end,
})

-- Defer utility modules until first use
local util_modules = { 'floaterminal', 'session', 'todo', 'tabs' }
for _, mod in ipairs(util_modules) do
  vim.defer_fn(function()
    require('custom.util.' .. mod)
  end, 0)
end

-- Bootstrap lazy.nvim plugin manager if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.loop or vim.uv).fs_stat(lazypath) then
  local lazy_repo = 'https://github.com/folke/lazy.nvim.git'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazy_repo, lazypath }
  local output = vim.fn.system(clone_cmd)
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. output)
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Plugin setup via lazy.nvim
require('lazy').setup({
  { import = 'custom.plugins' },
  { import = 'custom.lsp' },
}, {
  defaults = {
    lazy = true, -- lazy load plugins by default
  },
  performance = {
    rtp = {
      reset = false, -- reset runtime path
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'zipPlugin',
        'netrwPlugin',
        'tohtml',
        'matchit',
        'matchparen',
        'rplugin',
        'editorconfig',
        'man',
        'spellfile',
      },
    },
  },
})

-- Update plugins manually with <leader>lu
vim.keymap.set('n', '<leader>lu', function()
  require('lazy').update()
end, { desc = 'Update plugins (lazy.nvim)' })
vim.keymap.set('n', '<leader>lp', function()
  require('lazy').profile()
end, { desc = 'Profile (lazy.nvim)' })
vim.keymap.set('n', '<leader>lh', function()
  require('lazy').home()
end, { desc = 'Home (lazy.nvim)' })
