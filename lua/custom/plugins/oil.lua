return {
  'stevearc/oil.nvim',
  lazy = true,
  -- event = { 'BufRead' }, -- Uncomment if you want to load on BufRead
  cmd = { 'Oil', 'Oil --float' }, -- Add Oil --float to cmd to load on floating oil as well
  keys = {
    { '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' } },
    -- Example keymap for floating window (uncomment if desired)
    -- { '<leader>-', function() require('oil').open_float() end, { desc = 'Open Oil in floating window' } },
  },
  opts = { -- Plugin options (customize as needed)
    default_file_explorer = true,
    columns = {
      'icon',
    },
    skip_confirm_for_simple_edits = false,
    use_default_keymaps = true, -- Set to false if you want to define all keymaps yourself
    view_options = {
      show_hidden = true,
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
  },
  dependencies = {
    -- { 'echasnovski/mini.icons', opts = {} }, -- Optional: mini.icons
    { 'nvim-tree/nvim-web-devicons' }, -- Uncomment to use nvim-web-devicons instead
  },
  -- The config function is not needed here as opts is used by lazy.nvim
  -- config = function()
  --   require('oil').setup {
  --     -- Configuration is now in the 'opts' table above
  --   }
  -- end,
}
