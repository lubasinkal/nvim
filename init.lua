-- Load essential configs early (keymaps, options)
require 'custom.keymaps'
require 'custom.options'
require 'custom.autocmds.sql-completion'

-- Bootstrap lazy.nvim plugin manager if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.loop or vim.uv).fs_stat(lazypath) then
  local lazy_repo = 'https://github.com/folke/lazy.nvim.git'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazy_repo, lazypath }
  local output = vim.fn.system(clone_cmd)
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. output)
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Plugin setup via lazy.nvim
require('lazy').setup({
  -- Indentation detection plugin
  {
    'NMAC427/guess-indent.nvim',
    event = 'BufReadPre',
  },
  -- Auto-close brackets/quotes intelligently
  { 'windwp/nvim-ts-autotag', opts = {}, event = { 'BufReadPre', 'BufNewFile' } },

  -- Better quick fix list
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

  -- Smooth scrolling
  { 'karb94/neoscroll.nvim', opts = {}, event = 'VeryLazy' },
  -- Lua development support for Neovim config files only
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Add luvit types when 'vim.uv' word is found (async support)
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = 'VeryLazy',
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
    end, -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  -- Mini.nvim modular plugins loaded on VeryLazy event for smooth startup
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup()
      require('mini.surround').setup()
      require('mini.comment').setup {
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }
    end,
  },
  { import = 'custom.plugins' },
  { import = 'custom.lsp' },
}, {
  defaults = {
    lazy = true, -- lazy load plugins by default
  },

  performance = {
    cache = { enabled = true }, -- cache plugin loader for faster startup
    reset_packpath = true, -- reset packpath for clean environment
    rtp = {
      reset = true, -- reset runtime path
      disabled_plugins = {
        -- These are safe and common to disable
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        -- Rarely needed extras
        'man',
        'shada_plugin',
        'spellfile_plugin',
        'vimballPlugin',
      },
    },
  },
})

-- Update plugins manually with <leader>lu
vim.keymap.set('n', '<leader>lu', function()
  require('lazy').update()
end, { desc = 'Update plugins (lazy.nvim)' })
vim.keymap.set('n', '<leader>lp', function()
  require('lazy').profile()
end, { desc = 'Profile (lazy.nvim)' })

-- -- Auto-update plugins every 24 hours (optional)
-- vim.defer_fn(function()
--   require('lazy').update()
-- end, 1000 * 60 * 60 * 24)
