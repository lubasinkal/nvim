return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown' },
  dependencies = { 'saghen/blink.cmp' },

  config = function()
    require('markview').setup {}
  end,
}
