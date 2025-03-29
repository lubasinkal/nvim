return {
  {
    'EdenEast/nightfox.nvim',
    -- name = 'nightfox',
    name = 'carbonfox',
    lazy = false, -- Load immediately
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme carbonfox' -- Apply colorscheme
    end,
  },
} -- lazy
