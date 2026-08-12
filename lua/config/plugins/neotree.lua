vim.pack.add { { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' } }
require('neo-tree').setup {
  window = {
    position = 'right',
    width = 25,
  },
}
