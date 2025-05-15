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
        timeout = 5000,
        background_colour = '#000000',
        render = 'wrapped-compact',
      },
    },
  },
}
