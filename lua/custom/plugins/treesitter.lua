return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'VeryLazy' },
  cmd = { 'TSUpdate' },
  branch = 'master',
  opts = {
    -- Install languages that are not already installed above
    auto_install = true,
    indent = { enable = true },
    highlight = { enable = true },
    folds = { enable = true },
    context_commentstring = {
      enable = true,
      enable_autocmd = true,
    },
  },
}
