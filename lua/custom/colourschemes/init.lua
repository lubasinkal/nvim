return {
  -- 'EdenEast/nightfox.nvim',
  -- name = 'carbonfox',
  -- 'nyoom-engineering/oxocarbon.nvim',
  -- name = 'oxocarbon',
  'scottmckendry/cyberdream.nvim',

  event = { 'VimEnter' },

  config = function()
    vim.cmd 'colorscheme cyberdream' -- Apply colorscheme
    vim.opt.background = 'dark' -- set this to dark or light
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  end,
}
