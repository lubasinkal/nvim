
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
  -- R.nvim plugin
  {
    "R-nvim/R.nvim",
    -- Only required if you also set defaults.lazy = true
    lazy = false,
    -- R.nvim is still young and we may make some breaking changes from time
    -- to time. For now we recommend pinning to the latest minor version
    -- like so:
    version = "~0.1.0"
  },

  -- cmp-r and nvim-cmp setup
  {
    "R-nvim/cmp-r",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("cmp").setup({
        sources = {
          { name = "cmp_r" }
        }
      })
      require("cmp_r").setup({})
    end,
  },

  -- nvim-treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv" },
        highlight = { enable = true },
      })
    end,
  },
}

