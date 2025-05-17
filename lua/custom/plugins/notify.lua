return {
  'rcarriga/nvim-notify',
  lazy = false, -- Ensure it loads on startup
  priority = 1000, -- High priority for loading
  opts = {
    timeout = 5000,
    render = 'wrapped-compact',
    level = vim.log.levels.INFO,
    icons = {
      ERROR = ' ',
      WARN = ' ',
      INFO = ' ',
      DEBUG = ' ',
      TRACE = 'Vim ',
    },
    stages = 'slide',
    topdown = false,
  },
  config = function(_, opts)
    local notify = require 'notify'
    notify.setup(opts)
    vim.notify = notify
  end,
}
