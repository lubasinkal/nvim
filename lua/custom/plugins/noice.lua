-- lazy.nvim
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  -- add any options here

  opts = {
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
    },
    views = {
      notify = {
        replace = true, -- This means Noice.nvim will replace nvim-notify's default notification view.
        -- Noice.nvim will still use nvim-notify as the backend for notification *data*
        -- but will render them according to Noice.nvim's own views.
      },
    },
    lsp = {
      signature = {
        auto_open = { enabled = false },
      },
      progress = {
        enabled = true,
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        -- throttle = 1000 / 30,
        view = 'notify', -- This tells Noice.nvim to use its 'notify' view for LSP progress.
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      opts = {
        timeout = 5000, -- How long notifications are displayed in milliseconds
        render = 'wrapped-compact', -- This might be overridden if Noice.nvim is replacing the view.
        level = vim.log.levels.INFO,
        icons = {
          ERROR = ' ',
          WARN = ' ',
          INFO = ' ',
          DEBUG = ' ',
          TRACE = 'Vim ',
        },
        stages = 'slide', -- This might be overridden if Noice.nvim is replacing the view.
        topdown = false, -- This might be overridden if Noice.nvim is replacing the view.
      },
    },
  },
}
