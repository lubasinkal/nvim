vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
local fzf = require 'fzf-lua'

fzf.setup {
  winopts = {
    height = 0.85,
    width = 0.80,
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

-- Search (prefixed with leader s)
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<CR>', { desc = 'Current Word' })
vim.keymap.set('v', '<leader>sw', '<cmd>FzfLua grep_visual<CR>', { desc = 'Current Selection' })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>sG', '<cmd>FzfLua grep_project<CR>', { desc = 'Grep (Project)' })
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua grep_curbuf<CR>', { desc = 'Grep Buffer' })
vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<CR>', { desc = 'Diagnostics (Workspace)' })
vim.keymap.set('n', '<leader>sr', '<cmd>FzfLua resume<CR>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>s.', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>ss', '<cmd>FzfLua builtin<CR>', { desc = 'FzfLua Builtin' })
vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>sn', function()
  require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Neovim Files' })
vim.keymap.set('n', '<leader>sH', '<cmd>FzfLua highlights<CR>', { desc = 'Highlights' })
vim.keymap.set('n', '<leader>sc', '<cmd>FzfLua colorschemes<CR>', { desc = 'Colorscheme' })
vim.keymap.set('n', '<leader>sR', '<cmd>FzfLua registers<CR>', { desc = 'Registers' })
vim.keymap.set('n', '<leader>s?', '<cmd>FzfLua spell_suggest<CR>', { desc = 'Spell Suggest' })

-- Git
vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<CR>', { desc = 'Git Files' })
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { desc = 'Git Commits' })
vim.keymap.set('n', '<leader>gC', '<cmd>FzfLua git_bcommits<CR>', { desc = 'Buffer Commits' })
vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Git Status' })

-- Buffers (prefixed with leader b)
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>br', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent' })
vim.keymap.set('n', '<leader>bm', '<cmd>FzfLua marks<CR>', { desc = 'Marks' })
vim.keymap.set('n', '<leader>bl', '<cmd>FzfLua blines<CR>', { desc = 'Buffer Lines' })
