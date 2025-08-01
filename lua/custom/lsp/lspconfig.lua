return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  config = function()
    -- [[ Configure LSP ]]
    -- This function gets run when an LSP attaches to a particular buffer.

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- LSP keymaps using which-key for groupings and descriptions
        local wk = require 'which-key'
        wk.add {
          { '<leader>c', buffer = event.buf, group = 'Code' },
          { '<leader>cn', vim.lsp.buf.rename, buffer = event.buf, desc = 'Rename' },
          { '<leader>ca', vim.lsp.buf.code_action, buffer = event.buf, desc = 'Code Action' },
          { '<leader>cr', require('telescope.builtin').lsp_references, buffer = event.buf, desc = 'References' },
          { '<leader>ci', require('telescope.builtin').lsp_implementations, buffer = event.buf, desc = 'Implementations' },
          { '<leader>cd', require('telescope.builtin').lsp_definitions, buffer = event.buf, desc = 'Definitions' },
          { '<leader>cD', vim.lsp.buf.declaration, buffer = event.buf, desc = 'Declaration' },
          { '<leader>ct', require('telescope.builtin').lsp_type_definitions, buffer = event.buf, desc = 'Type Definitions' },
          { '<leader>co', require('telescope.builtin').lsp_document_symbols, buffer = event.buf, desc = 'Document Symbols' },
          { '<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, buffer = event.buf, desc = 'Workspace Symbols' },
        }

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      -- virtual_lines = {
      --   only_current_line = false, -- Show on all lines with diagnostics
      --   highlights = {
      --     [vim.diagnostic.severity.ERROR] = 'DiagnosticVirtualTextError',
      --     [vim.diagnostic.severity.WARN] = 'DiagnosticVirtualTextWarn',
      --     [vim.diagnostic.severity.INFO] = 'DiagnosticVirtualTextInfo',
      --     [vim.diagnostic.severity.HINT] = 'DiagnosticVirtualTextHint',
      --   },
      -- },
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }
    -- LSP servers and clients are able to communicate to each other what features they support.
    -- By default, Neovim doesn't support everything that is in the LSP specification.
    -- When you add blink.cmp, Neovim now has *more* capabilities.
    -- So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- Enable the following language servers
    -- Feel free to add/remove any LSPs that you want here. They will automatically be installed by Mason.
    --
    -- Add any additional override configuration in the following tables. Available keys are:
    -- - cmd (table): Override the default command used to start the server
    -- - filetypes (table): Override the default list of associated filetypes for the server
    -- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    -- - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

    -- NOTE: This is where you add functionality for code analysis, static type checking and formating. Press :Mason search for the LSP, linter or formater for the programming languange, get the name and add it under servers.

    local vue_typescript_plugin = vim.fn.expand(vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server')
    local servers = {

      gopls = {},
      basedpyright = {},
      r_language_server = {},
      tailwindcss = {},
      cssls = {},
      emmet_language_server = {
        filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'vue' },
      },
      ts_ls = {
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_typescript_plugin,
              languages = { 'vue' },
            },
          },
        },
      },
      lua_ls = {},
      marksman = {}, -- Markdown LSP
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'ruff',
      'biome',
      'vue_ls',
      'vtsls',
    })

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
      run_on_start = false, -- disable here to manually control timing
      auto_update = true,
    }
    -- Async install without blocking
    vim.defer_fn(function()
      vim.cmd 'MasonToolsUpdate'
    end, 3000) -- 3 second delay
    require('mason-lspconfig').setup {

      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = true,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
    -- managed to get vue-language-server working with vtsls following https://github.com/vuejs/language-tools/wiki/Neovim
    local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    -- Check if the plugin path exists
    if vim.fn.isdirectory(vue_language_server_path) == 0 then
      vim.schedule(function()
        vim.notify(
          '[vtsls] @vue/typescript-plugin is missing! Please run :MasonToolsUpdate or install vue-language-server manually.',
          vim.log.levels.WARN,
          { title = 'LSP Setup' }
        )
      end)
    end
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    }

    local vue_ls_config = {
      on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
          local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
          if #clients == 0 then
            vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
            command = 'typescript.tsserverRequest',
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
            local response_data = { { id, r.body } }
            ---@diagnostic disable-next-line: param-type-mismatch
            client:notify('tsserver/response', response_data)
          end)
        end
      end,
    }
    -- nvim 0.11 or above
    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.enable { 'vtsls', 'vue_ls' }
  end,
}
