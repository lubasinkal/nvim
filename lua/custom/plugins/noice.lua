-- lazy.nvim
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  -- add any options here

  opts = function(_, opts)
    opts.routes = opts.routes or {}

    table.insert(opts.routes, {
      filter = {
        event = 'notify',
        find = 'No information available',
      },
      opts = { skip = true },
    })

    local focused = true
    vim.api.nvim_create_autocmd('FocusGained', {
      callback = function()
        focused = true
      end,
    })
    vim.api.nvim_create_autocmd('FocusLost', {
      callback = function()
        focused = false
      end,
    })

    table.insert(opts.routes, 1, {
      filter = {
        cond = function()
          return not focused
        end,
      },
      view = 'notify_send',
      opts = { stop = false },
    })

    opts.commands = {
      all = {
        view = 'split',
        opts = { enter = true, format = 'details' },
        filter = {},
      },
    }

    opts.presets = opts.presets or {}
    opts.presets.lsp_doc_border = true
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      'rcarriga/nvim-notify',
      opts = {
        timeout = 5000, -- How long notifications are displayed in milliseconds
        -- background_colour = '#000000', -- Setting background here might not respect terminal transparency or highlights.
        -- Consider using highlights instead (see below)
        render = 'wrapped-compact', -- How notifications are rendered ('default', 'compact', 'wrapped-compact', 'minimal')
        level = vim.log.levels.INFO, -- Minimum notification level to display (TRACE, DEBUG, INFO, WARN, ERROR)
        icons = { -- Customize icons for each level
          ERROR = ' ',
          WARN = ' ',
          INFO = ' ',
          DEBUG = ' ',
          TRACE = 'Vim ', -- You might need Nerd Fonts for these icons to display correctly
        },
        stages = 'slide', -- Animation style ('fade', 'slide', 'static')
        topdown = false, -- Display new notifications above existing ones
        -- max_height = nil,         -- Maximum height of the notification window
        -- max_width = nil,          -- Maximum width of the notification window
        -- placement = 'bottom',     -- Where notifications appear ('top', 'bottom', 'top-right', 'bottom-right', etc.)
        -- 'bottom' is often the default and behaves like the command line
        -- on_open = function(win) end, -- Callback function when a notification window is opened
        -- on_close = function(win) end, -- Callback function when a notification window is closed
      },
    },
  },
}
