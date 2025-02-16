return {
  'nvim-lualine/lualine.nvim',
  -- lazy = true,
  event = { 'UIEnter' }, -- This event is fine but consider alternatives based on usage
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      theme = 'auto', -- Change this to your preferred theme
      icons_enabled = true,
      section_separators = { '', '' },
      component_separators = { '', '' },
      globalstatus = true, -- Display the statusline in all windows
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          { 'filename', icon_only = true }, -- Show icon only for the filename
          'diagnostics', -- Show diagnostics
        },
        lualine_x = {
          'encoding',
          'filetype',
          -- 'fileformat', -- Shows OS ICON apparently
          {
            'progress',
            separator = ' | ',
            padding = { left = 1, right = 1 },
          },
        },
        lualine_y = { 'searchcount', 'location' },
        -- lualine_z = {'os.date("%H:%M:%S")'}, -- Show current time
      },
    }
  end,
}
