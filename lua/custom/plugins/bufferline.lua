return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'Bdelete! %d', -- Use Bdelete to close buffers cleanly
        buffer_close_icon = '', -- Hide close icon on buffers
        close_icon = '', -- Hide close icon on right side
        modified_icon = '●', -- Minimal dot for modified buffers
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 20,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diagnostics_dict)
          local icons = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          }

          local order = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          }

          local result = {}
          for _, severity in ipairs(order) do
            local count = diagnostics_dict[severity]
            if count and count > 0 then
              table.insert(result, icons[severity] .. count)
            end
          end

          return table.concat(result, ' ')
        end,
        diagnostics_update_in_insert = false,
        color_icons = true,
        show_buffer_icons = true, -- Show filetype icons
        show_buffer_close_icons = false, -- Disable close icons on buffers
        show_close_icon = false, -- Disable close icon on the right
        persist_buffer_sort = true,
        separator_style = { '│', '│' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false, -- No indicators (e.g. underline or icon)
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'none', -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = '󰐃',
        minimum_padding = 0, -- Minimal padding for compact look
        maximum_padding = 1,
        maximum_length = 20,
        sort_by = 'insert_at_end',
      },
      highlights = {
        separator = {
          fg = '#434C5E',
        },
        buffer_selected = {
          bold = true,
          italic = false,
        },
      },
    }
  end,
}
