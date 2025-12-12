-- Load essential configs early (keymaps, options)
require 'custom.keymaps'
require 'custom.options'
require 'custom.statusline'
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

    -- Better quick fix list
    { 'kevinhwang91/nvim-bqf',  ft = 'qf' },

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
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '1.*',
        opts = {
            port = 8181,
        }, -- lazy.nvim will implicitly calls `setup {}`
    },

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
    {
        'hat0uma/csvview.nvim',
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { '#', '//' } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { 'if', mode = { 'o', 'x' } },
                textobject_field_outer = { 'af', mode = { 'o', 'x' } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
                jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
                jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
                jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
            },
        },
        cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    },
    { import = 'custom.plugins' },
    { import = 'custom.lsp' },
}, {
    defaults = {
        lazy = true, -- lazy load plugins by default
    },

    performance = {
        cache = { enabled = true }, -- cache plugin loader for faster startup
        reset_packpath = true,      -- reset packpath for clean environment
        rtp = {
            reset = true,           -- reset runtime path
            -- Add these to your disabled_plugins list
            disabled_plugins = {
                -- Your existing disabled plugins
                'gzip',
                'matchit',
                'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
                'man',
                'spellfile_plugin',
                'vimballPlugin',

                -- Additional plugins that are safe to disable
                -- '2html_plugin',
                -- 'getscript',
                -- 'getscriptPlugin',
                -- 'logipat',
                -- 'rrhelper',
                -- 'shada_plugin',
                --
                -- -- Language providers (if you don't use them)
                -- -- 'node_provider',
                -- 'perl_provider',
                -- -- 'python3_provider', -- Only disable if you use other Python LSP
                -- 'ruby_provider',
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

-- Auto-update plugins every 24 hours (optional)
vim.defer_fn(function()
    require('lazy').update()
end, 1000 * 60 * 60 * 24)

-- Minimal Dev-Friendly ShaDa Setup
-- Keeps history, marks, registers, etc.
vim.o.shada = "!,'300,<50,s10,h"

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
-- Autocmd to remove trailing whitespace on save for most file types
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*' }, -- Apply to all files
    command = [[:%s/\s\+$//e]],
    desc = 'Remove trailing whitespace before saving',
})

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
