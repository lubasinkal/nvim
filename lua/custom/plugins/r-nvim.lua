-- R-nvim plugin for R interaction
-- Conditionally loads based on the presence of the R executable.
-- NOTE: This plugin requires a C compiler and, on Windows, Rtools
-- to build its helper package, nvimcom.
-- See: https://cran.r-project.org/bin/windows/Rtools/
return {
  'R-nvim/R.nvim',
  -- Only load this plugin if the 'R' executable is found in the path
  cond = vim.fn.executable 'R' == 1,
  ft = { 'r', 'rnoweb', 'quarto' },
  dependencies = {
    { 'R-nvim/cmp-r' },
    {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        -- Ensure the ensure_installed table exists
        opts.ensure_installed = opts.ensure_installed or {}
        -- Add R-related parsers to the list
        vim.list_extend(opts.ensure_installed, { 'r', 'rnoweb' })
      end,
    },
  },
  opts = {
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event
        -- of files supported by R.nvim. This is an
        -- opportunity to create mappings local to buffers.
        vim.keymap.set('n', '<Enter>', '<Plug>RDSendLine', { buffer = true })
        vim.keymap.set('v', '<Enter>', '<Plug>RSendSelection', { buffer = true })

        local wk = require 'which-key'
        wk.add {
          buffer = true,
          mode = { 'n', 'v' },
          { '<localleader>a', group = 'all' },
          { '<localleader>b', group = 'between marks' },
          { '<localleader>c', group = 'chunks' },
          { '<localleader>f', group = 'functions' },
          { '<localleader>g', group = 'goto' },
          { '<localleader>i', group = 'install' },
          { '<localleader>k', group = 'knit' },
          { '<localleader>p', group = 'paragraph' },
          { '<localleader>q', group = 'quarto' },
          { '<localleader>r', group = 'r general' },
          { '<localleader>s', group = 'split or send' },
          { '<localleader>t', group = 'terminal' },
          { '<localleader>v', group = 'view' },
        }
      end,
    },
  },
  config = function(_, opts)
    vim.g.rout_follow_colorscheme = true
    require('r').setup(opts)
    require('r.pdf.generic').open = vim.ui.open
  end,
}
