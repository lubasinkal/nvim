return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'biome' },
      typescript = { 'biome' },
      javascriptreact = { 'biome' },
      typescriptreact = { 'biome' },
      vue = { 'biome' },
      html = { 'biome' },
      css = { 'biome' },
      json = { 'biome' },
      yaml = { 'biome' },
      markdown = { 'prettier' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    notify_on_error = true,
    notify_no_formatters = true,
  },
}
