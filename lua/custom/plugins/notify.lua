return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  opts = {
    -- Default timeout (in ms)
    timeout = 3000,
    -- Display newer notifications at top
    top_down = false,
    -- Minimum log level (optional use)
    level = vim.log.levels.INFO,
    -- Animation style: "fade_in_slide_out", "slide", etc.
    stages = 'fade_in_slide_out',
    -- Default render style: "compact", "minimal", "default"
    render = 'compact',
    -- Highlight groups can be customized:
    -- Uncomment and override as needed:
    -- icons = {
    --   ERROR = '',
    --   WARN  = '',
    --   INFO  = '',
    -- },
    -- Optional: expose history via telescope or default UI
  },
  config = function(_, opts)
    local notify = require 'notify'
    notify.setup(opts)

    -- Set global vim.notify to use nvim-notify
    vim.notify = notify

    -- Optional: expose history commands
    vim.api.nvim_create_user_command('Notifications', function()
      require('notify').history()
    end, { desc = 'Show notifications history' })

    vim.api.nvim_create_user_command('NotificationsClear', function()
      require('notify').clear_history()
    end, { desc = 'Clear notifications history' })
  end,
}
