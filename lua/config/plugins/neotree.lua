vim.pack.add { { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' } }
require('neo-tree').setup {
  window = {
    position = 'right',
    width = 25,
  },
}
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer' })
