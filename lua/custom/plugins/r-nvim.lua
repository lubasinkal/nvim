-- Rtools may be an issue for people without it
--
-- FIX: DEPENDENCIES
--
-- Make and C compiler
--       GNU make and a C compiler (e.g. gcc or clang) must be installed to
--       build the the R package nvimcom which is included in R.nvim and is
--       automatically installed and updated whenever necessary.
--
-- TODO: On Windows, you have to install Rtools to be able to build nvimcom:
--       https://cran.r-project.org/bin/windows/Rtools/
--

-- TODO: Uncomment only if you have the dependencies setup. :wq then open nvim R.nvim should then build automatically

return {
  'R-nvim/R.nvim',
  lazy = false, -- Ensures the plugin loads immediately if lazy loading is enabled globally
  version = '~0.1.0', -- Pin to a minor version

  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate', -- Correct way to run post-install commands in lazy.nvim
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { 'markdown', 'markdown_inline', 'r', 'rnoweb', 'yaml', 'latex', 'csv' },
          highlight = { enable = true },
        }
      end,
    },
  },
}
