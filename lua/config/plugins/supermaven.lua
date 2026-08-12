vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<C-l>',
    clear_suggestion = '<C-]>',
  },
  ignore_filetypes = {
    bigfile = true,
  },
  color = {
    suggestion_color = '#6c7086',
    cterm = 244,
  },
  log_level = 'off',
  disable_inline_completion = false,
}
