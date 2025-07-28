return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPost',
  dependencies = 'nvim-web-devicons',
  config = function()
    local colors = {
      blue = '#80a0ff',
      cyan = '#79dac8',
      black = '#0d0d0f',
      white = '#c6c6c6',
      red = '#ff5189',
      violet = '#d183e8',
      grey = '#08080f',
      mustard = '#f2c811',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
      },
      insert = {
        a = { fg = colors.black, bg = colors.blue },
      },
      visual = {
        a = { fg = colors.black, bg = colors.cyan },
      },
      replace = {
        a = { fg = colors.black, bg = colors.red },
      },
      command = {
        a = { fg = colors.black, bg = colors.mustard },
      },
      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
      },
    }

    local function lsp_clients()
      local clients = vim.lsp.get_clients { bufnr = 0 }
      if next(clients) == nil then
        return 'No LSP'
      end
      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      return ' ' .. table.concat(names, ', ')
    end
    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'branch', icon = '' }, 'diff', 'diagnostics' },
        lualine_c = { '' },
        lualine_x = { lsp_clients, 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        -- lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_c = {
          {
            'filename',
            path = 1,
            file_status = true,
          },
        },
      },
      inactive_winbar = {},
      extensions = { 'nvim-tree', 'fugitive', 'lazy', 'trouble', 'quickfix', 'toggleterm' },
    }
  end,
}
