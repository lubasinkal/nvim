return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' }, -- Load after reading a file or creating a new one
  cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' }, -- Allow running these commands manually
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
    -- You had 'saghen/blink.cmp' commented out. If you intend to use it,
    -- uncomment it here and its related lines in the config function.
  },
  config = function()
    -- [[ Configure LSP ]]
    --
    -- This function gets run when an LSP attaches to a particular buffer.
    -- That is to say, every time a new file is opened that is associated with
    -- an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    -- function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }), -- Changed group name for clarity
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Common LSP keymaps
        -- Use Telescope pickers for list-like results
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        -- Changed from '<leader>D' to 'gt' which is more standard for 'goto type'
        map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Direct LSP actions
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- Standard Neovim built-in mapping
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>sh', vim.lsp.buf.signature_help, 'Signature Help') -- Use '<C-h>' in insert mode

        -- Code action picker (using Telescope ui-select which you have installed)
        map('<leader>ca', function()
          vim.lsp.buf.code_action { apply = true, context = { only = { 'quickfix', 'refactor', 'source', 'organizeImports' } } }
        end, '[C]ode [A]ction', { 'n', 'x' })
        -- Alternative using ui-select:
        map('<leader>cA', function()
          require('telescope.builtin').code_action()
        end, '[C]ode [A]ction (Picker)', { 'n', 'x' })

        -- Formatting (requires a formatter to be configured, e.g., via LSP or null-ls)
        map('<leader>fm', function()
          vim.lsp.buf.format { async = true }
        end, '[F]or[m]at')

        -- Show hover documentation
        map('K', vim.lsp.buf.hover, 'Hover Documentation') -- Standard Neovim built-in mapping

        -- Show LSP information for the current buffer
        map('<leader>li', vim.lsp.buf.type_definition, 'LSP Info') -- Used type_definition here, often shows type and docs

        -- Diagnostic keymaps
        -- Navigate diagnostics
        map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
        map('<leader>dl', vim.diagnostic.open_float, 'Show line diagnostics') -- Show diagnostics in a float window
        map('<leader>db', require('telescope.builtin').diagnostics, 'Buffer diagnostics') -- List buffer diagnostics
        map('<leader>dw', function()
          require('telescope.builtin').diagnostics { bufnr = 0 } -- List workspace diagnostics
        end, 'Workspace diagnostics')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        -- See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- Check if the server supports documentHighlight before setting up autocmds
        if client and client.supports_method 'textDocument/documentHighlight' then
          local highlight_augroup = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false }) -- Changed group name
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
            group = vim.api.nvim_create_augroup('custom-lsp-detach', { clear = true }), -- Changed group name
            buffer = event.buf, -- Ensure this only runs for the detaching buffer
            callback = function()
              vim.lsp.buf.clear_references()
              -- Clear the highlight augroup for the buffer when LSP detaches
              vim.api.nvim_del_augroup_by_id(highlight_augroup)
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        -- Check if the server supports inlayHint before setting up keymap
        if client and client.supports_method 'textDocument/inlayHint' then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.config()
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font
          and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ', -- error
              [vim.diagnostic.severity.WARN] = '󰀪 ', -- warn
              [vim.diagnostic.severity.INFO] = '󰋽 ', -- info
              [vim.diagnostic.severity.HINT] = '󰌶 ', -- hint
            },
          }
        or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          -- Only show the message for virtual text
          return diagnostic.message
        end,
      },
      -- Show diagnostics in the sign column, with virtual text, and in a float
      -- Enable these as needed:
      -- virtual_lines = { only_current_line = true }, -- Show virtual lines below the current line
    }

    -- LSP servers and clients are able to communicate to each other what features they support.
    -- By default, Neovim doesn't support everything that is in the LSP specification.
    -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Use cmp_nvim_lsp capabilities
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    -- If you are using blink.cmp uncomment the following:
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

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

    local util = require 'lspconfig.util'

    local servers = {

      gopls = {

        cmd = { 'gopls' },

        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },

        settings = {

          gopls = {

            completeUnimported = true,
          },
        },
      }, -- GoLang LSPs

      pyright = {
        python = {
          analysis = {
            autoSearchPaths = true, -- Enable auto searching for Python packages
            diagnosticMode = 'openFilesOnly', -- Analyze only open files
            useLibraryCodeForTypes = true, -- Include library code for type analysis
            extraPaths = { './.venv/Lib/site-packages' },
          },
          venvPath = '.', -- Look for the virtual environment in the current directory
        },
      },
      r_language_server = {
        -- Use a dynamic command based on OS and package availability
        root_dir = function(fname)
          return require('lspconfig.util').root_pattern('DESCRIPTION', 'NAMESPACE', '.Rbuildignore')(fname)
            or require('lspconfig.util').find_git_ancestor(fname)
            or vim.loop.os_homedir()
        end,
      },
      html = {},
      tailwindcss = {},
      cssls = {},

      -- Vue 3 + TypeScript
      volar = {},
      ts_ls = {
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              -- Adjust the path if necessary based on where Mason installs volar
              location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
              languages = { 'vue' },
            },
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
            -- Add Neovim runtime to the Lua language server
            workspace = {
              library = {
                [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                [vim.fn.stdpath 'config' .. '/lua'] = true,
              },
              checkThirdParty = false, -- Set to true to check dependencies
            },
            telemetry = { enabled = false }, -- Disable telemetry
          },
        },
      },

      -- Add other servers here like:
      -- ccls = { root_dir = root_pattern },
      -- clangd = { root_dir = root_pattern },
      -- rust_analyzer = { root_dir = root_pattern },
      -- tsserver = { root_dir = root_pattern }, -- Standard TypeScript server if you don't use ts_ls
      -- jsonls = { root_dir = root_pattern },
      -- yamlls = { root_dir = root_pattern },
      -- marksman = { root_dir = root_pattern }, -- Markdown LSP
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
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
  end,
}
