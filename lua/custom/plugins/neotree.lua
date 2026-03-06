return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = { { '<leader>e', '<Cmd>Neotree<CR>', desc = 'Toggle File Explorer' } },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    -- options go here
  },
}
