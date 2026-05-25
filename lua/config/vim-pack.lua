-- vim.pack: Neovim 0.12 built-in plugin manager
--
-- Plugin hooks and keymaps. Each plugin config in lua/config/plugins/
-- and lua/config/lsp/ calls vim.pack.add() independently ("many add" style).

local M = {}

-- ── Hooks (must be registered before any vim.pack.add() call) ──

vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('PackHooks', { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        -- Update tree-sitter parsers after updating nvim-treesitter
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd.TSUpdate()
        end
    end,
})

-- ── Load all plugin configs ──

function M.load_all()
    -- Core dependencies (must load first)
    require('config.plugins.deps')

    -- UI / visual
    require('config.plugins.whichkey')
    require('config.plugins.colorscheme')
    require('config.plugins.markdown')
    require('config.plugins.todo')

    -- Treesitter
    require('config.plugins.treesitter')

    -- Editing / navigation
    require('config.plugins.flash')
    require('config.plugins.mini')
    require('config.plugins.gitsigns')
    require('config.plugins.neotree')
    require('config.plugins.oil')
    require('config.plugins.lazygit')

    -- Telescope
    require('config.plugins.telescope')

    -- LSP / completion
    require('config.lsp.autocomplete')
    require('config.lsp.lspconfig')

    -- Misc
    require('config.plugins.typst')
end

-- ── Keymaps ──

vim.keymap.set('n', '<leader>lu', function()
    vim.pack.update()
end, { desc = 'Update plugins' })

vim.keymap.set('n', '<leader>lU', function()
    vim.pack.update(nil, { force = true })
end, { desc = 'Update plugins (force, no confirm)' })

vim.keymap.set('n', '<leader>ll', function()
    local plugins = vim.pack.get()
    local lines = {}
    for _, p in ipairs(plugins) do
        lines[#lines + 1] = string.format('  %s  %s', p.active and '✓' or ' ', p.spec and p.spec.name or '?')
    end
    table.sort(lines)
    print('Installed plugins:\n' .. table.concat(lines, '\n'))
end, { desc = 'List plugins' })

return M
