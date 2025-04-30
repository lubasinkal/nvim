return {
  'nvim-lualine/lualine.nvim',
  lazy = true,
  event = { 'BufRead' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto', -- You can replace 'auto' with your preferred theme
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          { 'mode', icon = '' },
        },
        lualine_b = {
          { 'branch', icon = '' },
          { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
          },
        },
        lualine_c = {
          {
            'filename',
            -- path = 1,
            symbols = {
              modified = ' ●',
              readonly = ' 🔒',
              unnamed = '[No Name]',
            },
          },
        },
        lualine_x = {
          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = { left = 1, right = 0 },
          },
          {
            'encoding',
            separator = ' ',
          },
          'fileformat',
        },
        lualine_y = { {
          'progress',
          separator = ' | ',
          padding = { left = 1, right = 1 },
        } },
        lualine_z = {
          -- function()
          --   return os.date(" %H:%M")
          -- end,
          { 'location', icon = '' },
        },
      },
      extensions = { 'nvim-tree', 'quickfix', 'fzf' },
    }
  end,
}
