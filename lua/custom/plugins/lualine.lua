return {
  'nvim-lualine/lualine.nvim',
  lazy = true,
  event = { 'BufRead' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local mode_color = {
      n = { fg = '#000000', bg = '#ADD8E6', gui = 'bold' }, -- Normal - Light Blue
      i = { fg = '#000000', bg = '#91FF72', gui = 'bold' }, -- Insert - Light Green
      v = { fg = '#000000', bg = '#E06AFF', gui = 'bold' }, -- Visual - Plum
      V = { fg = '#000000', bg = '#DDA0DD', gui = 'bold' }, -- Visual Line
      [''] = { fg = '#000000', bg = '#DDA0DD', gui = 'bold' }, -- Visual Block
      c = { fg = '#000000', bg = '#FFD700', gui = 'bold' }, -- Command - Gold
      s = { fg = '#000000', bg = '#FF7F7F', gui = 'bold' }, -- Select - Light Red
      R = { fg = '#000000', bg = '#BFBFBF', gui = 'bold' }, -- Replace - Pale Yellow
      t = { fg = '#000000', bg = '#AFEEEE', gui = 'bold' }, -- Terminal - Pale Turquoise
    }

    require('lualine').setup {
      options = {
        theme = 'auto',
        icons_enabled = true,
        component_separators = { left = '|', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icon = '',
            color = function()
              -- Get the current mode
              local mode = vim.fn.mode()
              return mode_color[mode] or { fg = '#ffffff', bg = '#4C566A', gui = 'bold' } -- fallback: dark gray
            end,
          },
        },
        lualine_b = { { 'branch', icon = '' } },
        lualine_c = {
          {
            'filename',
            symbols = {
              modified = ' ●',
              readonly = ' 🔒',
              unnamed = '[No Name]',
            },
          },
        },
        lualine_x = {
          { 'filetype', icon_only = true },
          'encoding',
        },
        lualine_y = { 'progress' },
        lualine_z = {
          {
            'location',
            icon = '',
            color = function()
              -- Get the current mode
              local mode = vim.fn.mode()
              return mode_color[mode] or { fg = '#ffffff', bg = '#4C566A', gui = 'bold' } -- fallback: dark gray
            end,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            symbols = {
              modified = ' ●',
              readonly = ' 🔒',
              unnamed = '[No Name]',
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
