vim.pack.add { 'https://github.com/chomosuke/typst-preview.nvim' }
require('typst-preview').setup { port = 6767 }

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function(event)
    vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreviewToggle<cr>', { buffer = event.buf, desc = 'Toggle Typst Preview' })
  end,
})
