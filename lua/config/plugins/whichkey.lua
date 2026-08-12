vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  preset = 'helix',
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = {}, -- nerd font glyphs (default) since have_nerd_font is true
  },
  spec = {
    { '<leader>b', group = 'Buffer' },
    { '<leader>s', group = 'Search' },
    { '<leader>g', group = 'Git' },
    { '<leader>u', group = 'UI / Toggles' },
    { '<leader>w', group = 'Sessions' },
    { '<leader>t', group = 'Terminal' },
    { '<leader>p', group = 'Pack' },
    { '<leader>e', group = 'Explorer' },
    { '<leader>q', group = 'Quickfix' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gs', group = 'Surround', mode = { 'n', 'x' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
  win = {
    wo = {
      winblend = 100,
    },
  },
}
