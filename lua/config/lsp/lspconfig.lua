vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
vim.pack.add({ 'https://github.com/williamboman/mason.nvim' })
vim.pack.add({ 'https://github.com/williamboman/mason-lspconfig.nvim' })
vim.pack.add({ 'https://github.com/j-hui/fidget.nvim' })

-- LspAttach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        local wk = require('which-key')
        wk.add {
            { 'gd', require('telescope.builtin').lsp_definitions, buffer = event.buf, desc = 'Goto Definition' },
            { 'gD', vim.lsp.buf.declaration, buffer = event.buf, desc = 'Goto Declaration' },
            { 'grr', require('telescope.builtin').lsp_references, buffer = event.buf, desc = 'Goto References' },
            { 'gri', require('telescope.builtin').lsp_implementations, buffer = event.buf, desc = 'Goto Implementation' },
            { 'grt', require('telescope.builtin').lsp_type_definitions, buffer = event.buf, desc = 'Type Definition' },
            { 'grn', vim.lsp.buf.rename, buffer = event.buf, desc = 'Rename' },
            { 'gra', vim.lsp.buf.code_action, buffer = event.buf, desc = 'Code Action', mode = { 'n', 'x' } },
            { 'gO', require('telescope.builtin').lsp_document_symbols, buffer = event.buf, desc = 'Document Symbols' },
            { '<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, buffer = event.buf, desc = 'Workspace Symbols' },
        }

        local function supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            end
            return client:supports_method(method, { bufnr = bufnr })
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf, group = group, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf, group = group, callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(e)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = e.buf }
                end,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = event.buf,
                callback = function()
                    vim.lsp.buf.format { async = false, id = event.data.client_id }
                end,
            })
        end
    end,
})

-- Lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME, '${3rd}/luv/library',
                    vim.fn.stdpath 'config', '${3rd}/busted/library',
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- TypeScript with Vue
vim.lsp.config('ts_ls', {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vim.fn.stdpath 'data'
                    .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                languages = { 'vue' },
                configNamespace = 'typescript',
            },
        },
    },
})

vim.lsp.config('vue_ls', {})

-- Mason
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { 'stylua', 'lua_ls' },
    automatic_enable = true,
}

-- Fidget
require('fidget').setup({
    notification = { window = { winblend = 0 } },
})
