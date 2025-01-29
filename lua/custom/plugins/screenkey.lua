return {
  'NStefan002/screenkey.nvim',
  lazy = true, -- Load the plugin immediately
  version = '*', -- or branch = "dev", to use the latest commit
  config = function()
    -- Map the keybinding for <leader>tk to toggle Screenkey
    vim.keymap.set('n', '<leader>tsk', function()
      vim.cmd 'Screenkey toggle' -- Toggles the Screenkey plugin
    end, { desc = '[T]oggle [S]creen[K]ey' })
  end,
}
