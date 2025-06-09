return {
  'stevearc/oil.nvim',
  lazy = true,
  cmd = { 'Oil', 'Oil --float' }, -- Add Oil --float to cmd to load on floating oil as well
  keys = {
    { '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' } },
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
    { 'nvim-tree/nvim-web-devicons' },
  },
}
