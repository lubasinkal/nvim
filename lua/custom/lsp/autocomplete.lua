return {
  'hrsh7th/nvim-cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdLineEnter' },
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
    'lukas-reineke/cmp-under-comparator',
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

    local kind_formatter = lspkind.cmp_format {
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[LSP]',
        path = '[path]',
        luasnip = '[snip]',
        nvim_lua = '[lua]',
      },
    }

    cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
      sources = cmp.config.sources {
        { name = 'vim-dadbod-completion', priority = 1000 },
        { name = 'buffer', priority = 300 },
      },
    })
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
      },
      performance = {
        debounce = 60,
        throttle = 30,
        confirm_resolve_timeout = 80,
        fetching_timeout = 100,
        async_budget = 20,
        max_view_entries = 15,
      },
      experimental = {
        ghost_text = {
          hl_group = 'Comment',
        },
        -- native_menu = true, -- enable if you want native menu dropdown
      },
      window = {
        completion = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CmpSel',
        },
        documentation = cmp.config.window.bordered {
          border = 'rounded',
          max_width = 80,
          max_height = 15,
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
        -- Smart Tab + Shift-Tab navigation
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'nvim_lua', priority = 900 },
        { name = 'luasnip', priority = 750 },
        { name = 'path', priority = 500 },
        { name = 'buffer', priority = 300 },
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require('cmp-under-comparator').under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = function(entry, vim_item)
          vim_item = kind_formatter(entry, vim_item)
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
