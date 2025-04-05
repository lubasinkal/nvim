return {
  'EdenEast/nightfox.nvim',
  -- name = 'nightfox',

  event = { 'BufRead', 'BufReadPre' },
  name = 'carbonfox',
  -- lazy = false, -- Load immediately
  -- priority = 100,
  config = function()
    vim.cmd 'colorscheme carbonfox' -- Apply colorscheme
  end,
}
