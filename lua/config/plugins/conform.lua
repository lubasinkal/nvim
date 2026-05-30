return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff', 'black' },
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
        yaml = { 'prettierd', 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        graphql = { 'prettierd', 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        go = { 'gofumpt', 'gofmt' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        toml = { 'taplo' },
        rust = { 'rustfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    }
  end,
}
