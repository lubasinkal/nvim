-- Load essential configuration first (keymaps and options)
require 'custom.keymaps'
require 'custom.options'

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install and configure your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  -- LSP configuration for Neovim Lua files
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua', -- Only load for Lua files
    opts = {
      library = {
        -- Add luvit types when the `vim.uv` word is found (useful for async operations)
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {},
  },
  -- Collection of various small independent plugins/modules (Mini.nvim)
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy', -- Load on VeryLazy for faster startup
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.indentscope').setup()
      require('mini.pairs').setup()
      require('mini.comment').setup {
        options = {
          -- Function to get the comment string based on Treesitter context
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }
    end,
  },

  { import = 'custom.plugins' }, -- Imports plugins defined in lua/custom/plugins/*.lua
  { import = 'custom.colourschemes' }, -- Imports colourscheme configurations
  { import = 'custom.lsp' }, -- Imports LSP configurations
}, { -- lazy.nvim options
  defaults = { lazy = true }, -- Set all plugins to lazy load by default
  ui = {
    -- Configure lazy.nvim UI icons
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },

  performance = {
    cache = { enabled = true }, -- Enable caching for faster startup
    reset_packpath = true, -- Reset packpath for a clean environment
    rtp = {
      reset = true, -- Reset the runtimepath
      disabled_plugins = { -- Disable built-in plugins you replace
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin', -- Often replaced by a file explorer plugin
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'osc52', -- Terminal feature, sometimes causes issues
        'man',
        'shada',
        'spellfile',
        'rplugin',
        'editorconfig',
        'health',
        'syntax',
        '2html_plugin',
        'getscript',
        'getscriptPlugin',
        'logipat',
        'remote_plugins',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'matchparen',
        'shada_plugin',
        'tar',
        'tarPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
})
