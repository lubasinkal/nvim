-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
-- Defer statusline until first buffer (saves ~5-10ms)
vim.api.nvim_create_autocmd({ 'BufEnter', 'UIEnter' }, {
    once = true,
    callback = function()
        require 'config.util.statusline'
    end,
})
