return {
  -- Autocompletion powered by nvim-cmp
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdLineEnter' }, -- Loads after Vim is fully entered. Can be 'InsertEnter' for maximum lazy-loading if preferred.
  version = '1.*', -- Ensure you're using a compatible version
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build step for LuaSnip's JS regexp support.
        -- Your conditional build is good for cross-platform compatibility.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` provides a wide range of pre-made snippets.
        -- Uncomment and configure if you want these snippets loaded.
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- nvim-cmp source for LuaSnip
    'onsails/lspkind.nvim', -- Adds icons and descriptions to completion items
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      completion = {

        -- 'menu,menuone,noinsert,noselect' is usually a good starting point.
        -- 'noselect' is important if you don't want the first item to be highlighted.
        completeopt = 'menu,menuone,noinsert,noselect',
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
        keyword_length = 2,
      },

      performance = {
        throttle = 0,
        filtering_context_budget = 10,
        async_budget = 10,
        confirm_resolve_timeout = 0,
        fetching_timeout = 0,
        debounce = 20, -- lower = faster but higher CPU
        max_view_entries = 8, -- reduces clutter and speeds up filtering
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
          hl_group_selected = "CmpItemAbbrMatch"
      }
      },
      window = {
        completion = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CmpSel,Search:None',
          zindex = 1001,
          scrolloff = 0,
          col_offset = 0,
          side_padding = 1,
          scrollbar = true,
        },
        documentation = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          zindex = 1000, -- Make it lower than completion/signature
          scrolloff = 0,
          col_offset = 0,
          side_padding = 1,
          scrollbar = true,
          max_width = 80, -- Example max width
          max_height = 10, -- Example max height
        },
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-k>'] = cmp.mapping.select_next_item(),
        ['<C-j>'] = cmp.mapping.select_prev_item(),

        -- Scroll documentation window: These will now only apply if the documentation window is explicitly open
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<C-e>'] = cmp.mapping.abort(), -- close completion window
        ['<C-Space>'] = cmp.mapping.complete {},
      },

      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'path', priority = 500 },
        { name = 'buffer', priority = 300 },
        { name = 'nvim_lsp_signature_help' },
      },

      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          menu = {
            buffer = '[buf]',
            nvim_lsp = '[LSP]',
            path = '[path]',
            luasnip = '[snip]',
            nvim_lsp_signature_help = '[sign]',
          },
        },
      },
    }
  end,
}
