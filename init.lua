-- Load essential configs early (keymaps, options)
require 'config.keymaps'
require 'config.options'

-- Defer statusline until first buffer (saves ~5-10ms)
vim.api.nvim_create_autocmd({ 'BufEnter', 'UIEnter' }, {
    once = true,
    callback = function()
        require 'config.statusline'
    end,
})

-- Defer utility modules until first use
local util_modules = { 'floaterminal', 'session', 'tabs' }
for _, mod in ipairs(util_modules) do
    vim.defer_fn(function()
        require('config.util.' .. mod)
    end, 0)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup via lazy.nvim
require('lazy').setup({
    spec = {
        { import = 'config.plugins' },
        { import = 'config.lsp' },
    },
    defaults = {
        lazy = true, -- lazy load plugins by default
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
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
