return {
  'stevearc/conform.nvim',
  event = 'BufWritePost',
  cmd = { 'ConformInfo', 'ConformFormat' },
  opts = {
    notify_on_error = true,
    format_on_save = { async = true, lsp_fallback = true },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff' },
      javascript = { 'biome' },
      typescript = { 'biome' },
      vue = { 'biome' },
      html = { 'biome' },
      css = { 'biome' },
      json = { 'biome' },
    },
  },
}
