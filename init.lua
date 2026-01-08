-- Load essential configs early (keymaps, options)
require 'custom.keymaps'
require 'custom.options'
require 'custom.statusline'

-- Load custom native utility modules
require 'custom.util.floaterminal'
require 'custom.util.session'
require 'custom.util.todo'
require 'custom.util.screenkey'

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
    -- Indentation detection plugin
    {
        'NMAC427/guess-indent.nvim',
        event = 'BufReadPre',
    },
    -- Auto-close brackets/quotes intelligently
    { 'windwp/nvim-ts-autotag', opts = {}, event = { 'BufReadPre', 'BufNewFile' } },

    -- Lua development support for Neovim config files only
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Add luvit types when 'vim.uv' word is found (async support)
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {'kevinhwang91/nvim-bqf', ft = 'qf'},
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = {},
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function(_, opts)
            require('nvim-autopairs').setup(opts)
        end, -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    -- Mini.nvim modular plugins loaded on VeryLazy event for smooth startup
    {
        'echasnovski/mini.nvim',
        event = 'InsertEnter',
        config = function()
            require('mini.comment').setup {
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring() or
                            vim.bo.commentstring
                    end,
                },
            }
        end,
    },
    { import = 'custom.plugins' },
    { import = 'custom.lsp' },
}, {
    defaults = {
        lazy = true, -- lazy load plugins by default
    },

    performance = {
        rtp = {
            reset = true, -- reset runtime path
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

-- Function to clean up ShaDa temp files
local function cleanup_shada()
    local notify = vim.notify
    local shada_dir = vim.fn.stdpath 'data' .. '/shada'

    if vim.fn.isdirectory(shada_dir) == 0 then
        notify('ShaDa directory not found: ' .. shada_dir, vim.log.levels.WARN)
        return
    end

    local pattern = shada_dir .. '/main.shada.tmp.*'
    local files = vim.fn.glob(pattern, false, true)

    if #files == 0 then
        notify('ShaDa cleanup: No temp files to remove.', vim.log.levels.INFO)
        return
    end

    notify('ShaDa cleanup: Found ' .. #files .. ' file(s) to remove.', vim.log.levels.INFO)

    for _, file in ipairs(files) do
        local ok, err = os.remove(file)
        if ok then
            notify('Deleted: ' .. file, vim.log.levels.DEBUG)
        else
            notify('Failed to delete ' .. file .. ': ' .. err, vim.log.levels.ERROR)
        end
    end
end

-- Keymap: <leader>sc to clean up ShaDa files
vim.keymap.set('n', '<leader>sc', cleanup_shada, { desc = 'Cleanup ShaDa temp files' })

-- Prevent LSP from sending ANY requests for oil:// buffers
local old_request = vim.lsp.buf_request
vim.lsp.buf_request = function(bufnr, method, params, handler)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("^oil://") then
        -- Skip the request entirely
        return
    end
    return old_request(bufnr, method, params, handler)
end
