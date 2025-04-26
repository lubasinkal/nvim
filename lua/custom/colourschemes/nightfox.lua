return {
  'EdenEast/nightfox.nvim',
  -- name = 'nightfox',

  event = { 'BufRead', 'BufReadPre' },
  name = 'carbonfox',
  -- lazy = false, -- Load immediately
  -- priority = 100,
  config = function()
    vim.cmd 'colorscheme carbonfox' -- Apply colorscheme
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    -- Noice specific highlight groups
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitle', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { bg = 'none' })
  end,
}
