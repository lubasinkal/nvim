return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff', 'black' },
        javascript = { 'biome', 'prettier' },
        typescript = { 'biome', 'prettier' },
        javascriptreact = { 'biome', 'prettier' },
        typescriptreact = { 'biome', 'prettier' },
        css = { 'biome', 'prettier' },
        html = { 'biome', 'prettier' },
        json = { 'biome', 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        go = { 'gofumpt', 'gofmt' },
        rust = { 'rustfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    }
  end,
}
