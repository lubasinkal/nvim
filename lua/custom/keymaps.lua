-- =============================================
-- LEADER KEYS
-- =============================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- =============================================
-- BASIC KEYMAPS
-- =============================================

-- Command mode shortcut
vim.keymap.set('n', ';', ':', { noremap = true, desc = 'Enter command mode' })

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Toggle diagnostic [Q]uickfix list' })

-- Terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- =============================================
-- WINDOW NAVIGATION
-- =============================================

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })

-- =============================================
-- PRODUCTIVITY KEYMAPS
-- =============================================
-- Move lines (Normal mode)
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })

-- Move lines (Visual mode)
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Dedent selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent selection' })

-- Paste over selection without yanking it
vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without yanking replaced text' })

-- =============================================
-- LSP & DIAGNOSTICS
-- =============================================

-- Toggle inlay hints
vim.keymap.set('n', '<leader>uh', function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
    vim.notify(enabled and "Inlay Hints Disabled" or "Inlay Hints Enabled")
end, { desc = 'Toggle inlay [H]ints' })

-- Toggle virtual lines diagnostics
vim.keymap.set('n', 'gk', function()
    local current = vim.diagnostic.config().virtual_lines or false
    vim.diagnostic.config { virtual_lines = not current }
end, { desc = 'Toggle diagnostic virtual lines' })

-- =============================================
-- UTILITIES
-- =============================================

-- Lazy load and open Undotree
vim.keymap.set('n', '<leader>ut', function()
    vim.cmd.packadd('nvim.undotree')
    require('undotree').open()
end, { desc = 'Open Undotree' })

-- =============================================
-- AUTOCOMMANDS
-- =============================================

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
