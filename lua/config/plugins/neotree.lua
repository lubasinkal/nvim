vim.pack.add({ 'https://github.com/nvim-neo-tree/neo-tree.nvim' })

require('neo-tree').setup({
    window = { position = 'right', width = 25 },
})

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer' })
