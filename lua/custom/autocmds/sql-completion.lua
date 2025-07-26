-- SQL completion configuration for vim-dadbod with blink.cmp
-- Since blink.cmp doesn't have direct vim-dadbod-completion support yet,
-- we set up an autocmd to enable enhanced completion for SQL files

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    -- Set omnifunc for SQL files to use vim-dadbod-completion
    vim.bo.omnifunc = 'vim_dadbod_completion#omni'
    
    -- Note: Users working with SQL files may want to consider using 
    -- nvim-cmp alongside blink.cmp specifically for database completion
    -- until direct blink.cmp integration is available
    
    -- Optional: Add a keymap to manually trigger omnifunc completion
    vim.keymap.set('i', '<C-x><C-o>', '<C-x><C-o>', { 
      buffer = true, 
      desc = 'SQL omni completion' 
    })
  end,
})
