return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown' },
  dependencies = { 'saghen/blink.cmp' },

  config = function()
    require('markview').setup {
      -- You can add your custom options here
    }

    -- Optional: Ensure Treesitter parsers (recommended for best experience)
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'markdown',
        'markdown_inline',
        'html',
        -- 'latex',  -- Requires treesitter cli installes
        'typst',
        'yaml',
      },
    }
  end,
}
