return {
  'hrsh7th/nvim-cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdLineEnter' },
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-nvim-lsp',
    'onsails/lspkind.nvim',
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    {
      'roobert/tailwindcss-colorizer-cmp.nvim',
      config = function()
        require('tailwindcss-colorizer-cmp').setup {
          color_square_width = 2,
        }
      end,
    },
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    luasnip.config.setup {}

    -- Prepare lspkind formatter
    local kind_formatter = lspkind.cmp_format {
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
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
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
        debounce = 20,
        max_view_entries = 8,
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },
      window = {
        completion = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CmpSel,Search:None',
          zindex = 1001,
          scrollbar = true,
        },
        documentation = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          zindex = 1000,
          max_width = 80,
          max_height = 10,
          scrollbar = true,
        },
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-k>'] = cmp.mapping.select_next_item(),
        ['<C-j>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<C-e>'] = cmp.mapping.abort(),
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
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = function(entry, vim_item)
          -- Apply lspkind icons and text
          vim_item = kind_formatter(entry, vim_item)

          -- Apply tailwind colorizer if available
          local ok, colorizer = pcall(require, 'tailwindcss-colorizer-cmp')
          if ok then
            vim_item = colorizer.formatter(entry, vim_item)
          end

          return vim_item
        end,
      },
    }
  end,
}
