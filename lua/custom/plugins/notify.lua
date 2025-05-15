return {
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
}
