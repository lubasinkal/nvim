return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile' }, -- Loads only when a file is opened

    -- lazy = true,
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
}
