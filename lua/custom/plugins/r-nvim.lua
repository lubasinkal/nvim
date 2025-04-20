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
  -- Only required if you also set defaults.lazy = true
  lazy = true,
  ft = 'r',
}
