-- vim.pack: Neovim 0.12 built-in plugin manager
--
-- Lazy loading strategy (per echasnovski's guide):
--   EAGER  — must be ready before first draw:
--             deps, mini.nvim, colorscheme, which-key
--   DEFERRED — loaded via vim.schedule() after startup:
--             everything else ("load not during startup" approach)

local M = {}

-- ── Hooks (must be registered before any vim.pack.add() call) ──

vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('PackHooks', { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd.TSUpdate()
        end
    end,
})

-- ── Eager: loaded before first draw ──

function M.load_eager()
    require('config.plugins.deps')        -- plenary, nui, fugitive, mini.icons
    require('config.plugins.mini')        -- statusline, notify, editor utilities
    require('config.plugins.whichkey')    -- keybinding discoverability
    require('config.plugins.colorscheme') -- visual appearance
end

-- ── Deferred: loaded after startup via vim.schedule() ──

function M.load_deferred()
    vim.schedule(function()
        require('config.plugins.gitsigns')
        require('config.plugins.treesitter')
        require('config.plugins.flash')
        require('config.plugins.neotree')
        require('config.plugins.oil')
        require('config.plugins.lazygit')
        require('config.plugins.todo')
        require('config.plugins.markdown')
        require('config.plugins.telescope')
        require('config.plugins.typst')
        require('config.lsp.autocomplete')
        require('config.lsp.lspconfig')
    end)
end

function M.load_all()
    M.load_eager()
    M.load_deferred()
end

-- ── Keymaps ──

vim.keymap.set('n', '<leader>pu', function()
    vim.pack.update()
end, { desc = 'Update plugins' })

vim.keymap.set('n', '<leader>pU', function()
    vim.pack.update(nil, { force = true })
end, { desc = 'Update plugins (force, no confirm)' })

vim.keymap.set('n', '<leader>pl', function()
    local plugins = vim.pack.get()
    local lines = {}
    for _, p in ipairs(plugins) do
        lines[#lines + 1] = string.format('  %s  %s', p.active and '✓' or ' ', p.spec and p.spec.name or '?')
    end
    table.sort(lines)
    print('Installed plugins:\n' .. table.concat(lines, '\n'))
end, { desc = 'List plugins' })

return M
