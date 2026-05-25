-- typst-preview.nvim
require('typst-preview').setup({
    port = 6767,
})

vim.keymap.set('n', '<leader>tp', function()
    vim.cmd('TypstPreviewToggle')
end, { desc = 'Toggle Typst Preview' })
