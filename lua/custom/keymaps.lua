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

-- Diagnostic navigation
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

-- Toggle diagnostics quickfix/loclist
local function toggle_loclist()
    local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
    if loclist_winid ~= 0 then
        vim.cmd.lclose()
    else
        vim.diagnostic.setloclist { open = true }
    end
end

vim.keymap.set('n', '<leader>q', toggle_loclist, { desc = 'Toggle diagnostic [Q]uickfix list' })

-- Terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- =============================================
-- WINDOW NAVIGATION
-- =============================================

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wx', '<C-w>c', { desc = 'Close current window' })

-- =============================================
-- PRODUCTIVITY KEYMAPS
-- =============================================

-- Reselect last visual selection
vim.keymap.set('n', 'gv', '`[v`]', { desc = 'Reselect last visual selection' })

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

-- Centered scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down + center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up + center' })

-- Fast save & quit
vim.keymap.set('n', '<leader>x', '<cmd>wq<CR>', { desc = '[X] Write and quit' })

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

-- ShaDa temp files cleanup
local function cleanup_shada()
    local shada_dir = vim.fn.stdpath('data') .. '/shada'
    if vim.fn.isdirectory(shada_dir) == 0 then
        vim.notify('ShaDa directory not found: ' .. shada_dir, vim.log.levels.WARN)
        return
    end

    local files = vim.fn.glob(shada_dir .. '/main.shada.tmp.*', false, true)

    if #files == 0 then
        vim.notify('ShaDa cleanup: No temporary files found.', vim.log.levels.INFO)
        return
    end

    vim.notify('ShaDa cleanup: Removing ' .. #files .. ' temporary file(s)...', vim.log.levels.INFO)

    for _, file in ipairs(files) do
        local ok, err = os.remove(file)
        if ok then
            vim.notify('Deleted: ' .. file, vim.log.levels.DEBUG)
        else
            vim.notify('Failed to delete ' .. file .. ': ' .. err, vim.log.levels.ERROR)
        end
    end
end

vim.keymap.set('n', '<leader>wc', cleanup_shada, { desc = 'Cleanup ShaDa temp files' })

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
