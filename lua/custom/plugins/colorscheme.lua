return {
  'catppuccin/nvim',
  name = 'catppuccin',
  event = 'VeryLazy',
  config = function()
    require('catppuccin').setup {
      transparent_background = true,
      auto_integrations = true,
      float = {
        transparent = true, -- enable transparent floating windows
      },
    }
    vim.cmd.colorscheme 'catppuccin-nvim'
    -- -- Defer statusline activation one more tick
    -- vim.schedule(function()
    --   require('custom.statusline').apply_highlights()
    --   vim.o.statusline = '%!v:lua.statusline()'
    --   vim.cmd 'redrawstatus!'
    -- end)
  end,
}
