return {
  {
    'nyoom-engineering/oxocarbon.nvim',
    name = 'oxocarbon',
    lazy = false, -- Load immediately
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme oxocarbon' -- Apply colorscheme
    end,
  },
}
