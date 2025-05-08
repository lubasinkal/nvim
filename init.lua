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
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

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

  -- Collection of various small independent plugins/modules (Mini.nvim)
  {
    'echasnovski/mini.nvim',
    event = 'BufReadPost', -- Load after reading a buffer

    -- Make nvim-ts-context-commentstring a dependency of mini.nvim
    -- This ensures it's loaded when mini.comment needs it
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },

    config = function()
      -- [[ Configure Mini.nvim Modules ]]
      -- See https://github.com/echasnovski/mini.nvim for more details and modules

      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Autopairs (if not using another autopairs plugin like nvim-autopairs)
      -- If you are using kickstart.plugins.autopairs, you can comment this out:
      -- require('mini.pairs').setup()

      -- Surrounded textobjects
      -- Examples:
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Commenting module
      -- Uses ts_context_commentstring for intelligent commenting
      require('mini.comment').setup {
        options = {
          -- Function to get the comment string based on Treesitter context
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }
      -- -- You can configure sections in the statusline by overriding their
      -- -- default behavior. For example, here we set the section for
      -- -- cursor location to LINE:COLUMN
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end
    end,
  },

  -- Import autopairs configuration (assuming this sets up nvim-autopairs or similar)
  -- If you are using mini.pairs, you can comment this out
  require 'kickstart.plugins.autopairs',

  -- NOTE: The imports below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' }, -- Imports plugins defined in lua/custom/plugins/*.lua
  { import = 'custom.colourschemes' }, -- Imports colourscheme configurations
  { import = 'custom.lsp' }, -- Imports LSP configurations
}, { -- lazy.nvim options

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
    -- Optional: Enable caching for faster startup (requires 'fennel' or 'lua-bytecode')
    -- cache = { enabled = true },
    -- Optional: Reset packpath (usually fine with modern plugin managers)
    -- reset_packpath = true,
    -- Configure runtimepath behavior
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
      },
    },
  },
  -- Add any other lazy.nvim options here
  -- install = { colorscheme = { "habamax" } }, -- Example: install habamax colorscheme on first run
  -- checker = { enabled = true }, -- Optional: Enable health check for plugins
  -- change_detection = { notify = false }, -- Optional: Disable notification on file changes
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
