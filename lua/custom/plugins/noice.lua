-- lazy.nvim
return {
  'folke/noice.nvim',
  lazy = true,
  event = { 'UIEnter', 'CmdlineEnter' }, -- Load when entering a command
  opts = {
    -- add any options here
  },

  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    { 'MunifTanjim/nui.nvim', module = 'nui' }, -- Ensure proper lazy loading
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    { 'rcarriga/nvim-notify', module = 'notify', lazy = true }, -- Load only when used
  },
}
