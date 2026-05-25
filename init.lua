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

-- ── Built-in package management (vim.pack) ──
local pack = require('config.pack')

-- First run: install missing plugins, then tell user to restart
local total, installed = 0, 0
for _, p in ipairs(pack.spec) do
    total = total + 1
    local dir = (p.lazy and pack.opt_dir or pack.start_dir) .. '/' .. p.name
    if vim.fn.isdirectory(dir) == 1 then
        installed = installed + 1
    end
end

if installed < total then
    vim.notify(string.format('[pack] Installing %d/%d plugins…', total - installed, total),
        vim.log.levels.INFO)
    local report = pack.install()
    print(report)
    vim.notify('[pack] Installation complete. Restart Neovim to load plugins.',
        vim.log.levels.INFO)
else
    require('config.pack-load').setup()
end

vim.keymap.set('n', '<leader>lu', function()
    local out = require('config.pack').update()
    print(out)
end, { desc = 'Update plugins (vim.pack)' })
vim.keymap.set('n', '<leader>ll', function()
    local out = require('config.pack').list()
    print(out)
end, { desc = 'List plugins (vim.pack)' })
vim.keymap.set('n', '<leader>lc', function()
    local out = require('config.pack').clean()
    local msg = #out > 0 and 'Removed: ' .. table.concat(out, ', ') or 'No orphaned plugins'
    print(msg)
end, { desc = 'Clean orphaned plugins (vim.pack)' })
vim.keymap.set('n', '<leader>ls', function()
    local out = require('config.pack').status()
    print(out)
end, { desc = 'Plugin git status (vim.pack)' })
