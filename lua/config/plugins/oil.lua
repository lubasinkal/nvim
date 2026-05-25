-- oil.nvim
require('oil').setup({
    lsp_file_methods = {
        enabled = false,
    },
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil (parent directory)' })
