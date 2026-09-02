vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/roobert/tailwindcss-colorizer-cmp.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' }, -- v1 stable, auto-downloads fuzzy binary
}

require('fidget').setup { notification = { window = { winblend = 0 } } }
require('tailwindcss-colorizer-cmp').setup { color_square_width = 2 }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
    ['<C-k>'] = { 'select_next', 'fallback' },
    ['<C-j>'] = { 'select_prev', 'fallback' },
    ['<C-y>'] = { 'accept', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  signature = { enabled = true },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true, window = { border = 'rounded' } },
  },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local wk = require 'which-key'
    wk.add {
      { 'gd', function() require('mini.extra').pickers.lsp { scope = 'definition' } end, buffer = event.buf, desc = 'Goto Definition' },
      { 'gD', vim.lsp.buf.declaration, buffer = event.buf, desc = 'Goto Declaration' },
      { 'grr', function() require('mini.extra').pickers.lsp { scope = 'references' } end, buffer = event.buf, desc = 'Goto References' },
      { 'gri', function() require('mini.extra').pickers.lsp { scope = 'implementation' } end, buffer = event.buf, desc = 'Goto Implementation' },
      { 'grt', function() require('mini.extra').pickers.lsp { scope = 'type_definition' } end, buffer = event.buf, desc = 'Type Definition' },
      { 'grn', vim.lsp.buf.rename, buffer = event.buf, desc = 'Rename' },
      { 'gra', vim.lsp.buf.code_action, buffer = event.buf, desc = 'Code Action', mode = { 'n', 'x' } },
      { 'gO', function() require('mini.extra').pickers.lsp { scope = 'document_symbol' } end, buffer = event.buf, desc = 'Document Symbols' },
      { '<leader>sS', function() require('mini.extra').pickers.lsp { scope = 'workspace_symbol' } end, buffer = event.buf, desc = 'Workspace Symbols' },
    }
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local hg = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = hg, callback = vim.lsp.buf.document_highlight })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = hg, callback = vim.lsp.buf.clear_references })
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

-- capabilities for blink
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function() capabilities = require('blink.cmp').get_lsp_capabilities(capabilities) end)

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
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
vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
        languages = { 'vue' },
        configNamespace = 'typescript',
      },
    },
  },
})

require('mason').setup { ensure_installed = { 'stylua' } }
require('mason-lspconfig').setup { ensure_installed = { 'lua_ls' }, automatic_enable = true }
