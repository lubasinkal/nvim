-- Rtools may be an issue for people without it
--
-- FIX: DEPENDENCIES
--
-- Make and C compiler
--       GNU make and a C compiler (e.g. gcc or clang) must be installed to
--       build the the R package nvimcom which is included in R.nvim and is
--       automatically installed and updated whenever necessary.
--
-- TODO:      VSCode Guide to install C compiler
--       https://code.visualstudio.com/docs/cpp/config-mingw
--
-- TODO: On Windows, you have to install Rtools to be able to build nvimcom:
--       https://cran.r-project.org/bin/windows/Rtools/
--

-- TODO: Uncomment only if you have the dependencies setup. :wq then open nvim R.nvim should then build automatically
return {
  -- R-nvim plugin for R interaction
  {
    'R-nvim/R.nvim',

    ft = 'r',
    dependencies = {
      { 'R-nvim/cmp-r' },
      {
        'nvim-treesitter/nvim-treesitter',
        opts = { ensure_installed = { 'r', 'rnoweb' } },
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
  },
  -- Autocompletion source for R from R-nvim
  -- This plugin integrates with nvim-cmp
}
