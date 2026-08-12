vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
}
vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
require('fidget').setup { notification = { window = { winblend = 0 } } }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local wk = require 'which-key'
    wk.add {
      { 'gd', require('fzf-lua').lsp_definitions, buffer = event.buf, desc = 'Goto Definition' },
      { 'gD', vim.lsp.buf.declaration, buffer = event.buf, desc = 'Goto Declaration' },
      { 'grr', require('fzf-lua').lsp_references, buffer = event.buf, desc = 'Goto References' },
      { 'gri', require('fzf-lua').lsp_implementations, buffer = event.buf, desc = 'Goto Implementation' },
      { 'grt', require('fzf-lua').lsp_type_definitions, buffer = event.buf, desc = 'Type Definition' },
      { 'grn', vim.lsp.buf.rename, buffer = event.buf, desc = 'Rename' },
      { 'gra', vim.lsp.buf.code_action, buffer = event.buf, desc = 'Code Action', mode = { 'n', 'x' } },
      { 'gO', require('fzf-lua').lsp_document_symbols, buffer = event.buf, desc = 'Document Symbols' },
      { '<leader>sS', require('fzf-lua').lsp_workspace_symbols, buffer = event.buf, desc = 'Workspace Symbols' },
    }

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library', vim.fn.stdpath 'config', '${3rd}/busted/library' },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
require('mason').setup {
  ensure_installed = { 'stylua' },
}
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls' },
  automatic_enable = true,
}
