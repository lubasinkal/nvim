require 'config.keymaps'
require 'config.options'
require 'config.autocmd'

-- Defer utility modules until first use
local util_modules = { 'floaterminal', 'session', 'tabs' }
for _, mod in ipairs(util_modules) do
    vim.defer_fn(function()
        require('config.util.' .. mod)
    end, 0)
end

-- ── vim.pack: Neovim 0.12 built-in plugin manager ──
require('config.pack').load_all()
