vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
local fzf = require 'fzf-lua'

fzf.setup {
  winopts = {
    preview = {
      layout = 'horizontal',
      horizontal = 'right:50%',
      scrollbar = false,
    },
  },
  keymap = {
    fzf = {
      ['ctrl-j'] = 'down',
      ['ctrl-k'] = 'up',
      ['ctrl-q'] = 'select-all+accept',
    },
    builtin = {
      ['ctrl-c'] = 'close',
      ['ctrl-x'] = 'jump-accept',
      ['ctrl-v'] = 'jump',
      ['ctrl-t'] = 'jump-tab',
    },
  },
  buffers = {
    sort_lastused = true,
    previewer = false,
    winopts = {
      height = 0.4,
      width = 0.6,
      row = 0.4,
    },
  },
  oldfiles = {
    include_current_session = true,
  },
  lsp = {
    async_or_timeout = 5000,
    symbols = {
      symbol_style = 1,
    },
  },
}

fzf.register_ui_select()
