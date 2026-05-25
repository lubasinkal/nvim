-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
-- Auto-center on InsertEnter (Your preference)
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        vim.cmd 'norm! zz'
    end,
})
-- Automatic window resizing
vim.api.nvim_create_autocmd({ 'VimResized' }, {
    callback = function()
        vim.cmd 'redraw!'
        vim.cmd 'wincmd ='
    end,
})
-- Vertical Help Page
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    command = 'wincmd L',
})
-- enable cursorline only in the active/current buffer/window and disable it when you leave
vim.api.nvim_create_augroup('CursorLineActive', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    group = 'CursorLineActive',
    callback = function()
        vim.wo.cursorline = true
    end,
})
vim.api.nvim_create_autocmd('WinLeave', {
    group = 'CursorLineActive',
    callback = function()
        vim.wo.cursorline = false
    end,
})
-- Diagnonstic floating window on cursorhold
vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        if next(vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })) then
            vim.diagnostic.open_float(nil, { focusable = false, border = 'rounded', scope = 'cursor' })
        end
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local filetype = vim.bo.filetype

        if filetype and filetype ~= "" then
            pcall(vim.treesitter.start)
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
    end,
})
