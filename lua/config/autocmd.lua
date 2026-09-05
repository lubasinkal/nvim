-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(ev)
    if vim.bo[ev.buf].filetype == '' then
      return
    end
    if pcall(vim.treesitter.get_parser, ev.buf) then
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.bo[ev.buf].indentexpr = 'v:lua.vim.treesitter.indentexpr()'
    end
  end,
})
