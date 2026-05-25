require 'config.keymaps'
require 'config.options'
require('config.autocmd')

-- Defer utility modules until first use
local util_modules = { 'floaterminal', 'session', 'tabs' }
for _, mod in ipairs(util_modules) do
    vim.defer_fn(function()
        require('config.util.' .. mod)
    end, 0)
end

-- ── vim.pack: Neovim 0.12 built-in plugin manager ──
-- Hooks, loader, keymaps are in config/vim-pack.lua
require('config.vim-pack').load_all()

vim.keymap.set('n', '<leader>lu', function()
    vim.pack.update()
end, { desc = '[U]pdate plugins' })
vim.keymap.set('n', '<leader>lU', function()
    vim.pack.update(nil, { force = true })
end, { desc = '[U]pdate plugins (force, no confirm)' })

