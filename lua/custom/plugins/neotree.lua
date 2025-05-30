return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',

  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle Neotree (Root Dir)', silent = true },
  },
  -- keys = {
  --   { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  -- },

  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<esc>'] = 'close_window',
        },
      },
    },
  },

  --   -- Keybinding to toggle Neotree in a floating window (Root Dir)
  --   vim.keymap.set('n', '<leader>e', function()
  --     vim.cmd 'Neotree float toggle'
  --   end, { desc = 'Toggle Neotree (Root Dir in Float)' })
  --
  --   -- Keybinding to toggle Neotree for the current working directory (cwd)
  --   --  vim.keymap.set("n", "<leader>E", function()
  --   -- vim.cmd("Neotree float toggle dir=" .. vim.loop.cwd())
  --   --  end, { desc = "Toggle Neotree (cwd in Float)" })
  -- end,
}
