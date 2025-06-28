return {
  'stevearc/oil.nvim',

  -- Lazy-load on specific commands or very lazy startup
  lazy = true,
  cmd = { 'Oil', 'Oil --float' },
  keys = {
    {
      '-',
      '<CMD>Oil --float<CR>',
      desc = 'Open Oil (parent directory)',
    },
  },

  -- Plugin options
  opts = {
    default_file_explorer = true, -- Replace netrw or other default explorer
    columns = { 'icon' },
    skip_confirm_for_simple_edits = false,
    use_default_keymaps = true, -- Set false to map manually
    view_options = {
      show_hidden = true, -- Show dotfiles
      natural_order = 'fast', -- Natural sorting (by type, then name)
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
  },

  -- Dependency for file icons
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}
