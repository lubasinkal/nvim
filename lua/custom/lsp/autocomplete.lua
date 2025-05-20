return {
  -- Autocompletion powered by blink.cmp
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdLineEnter' }, -- Loads after Vim is fully entered. Can be 'InsertEnter' for maximum lazy-loading if preferred.
  version = '1.*', -- Ensure you're using a compatible version
  dependencies = {
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
      opts = {
        -- LuaSnip setup options. These apply globally for LuaSnip.
        -- You might want to add similar options you had for nvim-cmp:
        store_selection_keys = true,
        enable_snipmate_visual_paste = true,
        update_events = { 'TextChanged', 'TextChangedI' },
      },
    },
    'folke/lazydev.nvim', -- Integration for completions from lazy-loaded plugins
    'onsails/lspkind.nvim', -- Still useful for customizing icons beyond blink.cmp's defaults
  },
  --- @type blink.cmp.Config
  opts = {
    -- **Speed & Keymap Optimization**
    keymap = {
      -- 'default' is recommended for mappings similar to built-in completions.
      -- It provides <c-y> to accept, handles auto-import, and snippet expansion.
      -- It also includes <tab>/<s-tab> for snippet navigation, <c-space> to open menu/docs,
      -- <c-n>/<c-p> for selection, <c-e> to hide, <c-k> to toggle signature help.
      preset = 'default',

      -- If you wish to use `<CR>` to confirm, you can explicitly map it:
      -- ['<CR>'] = blink.cmp.mapping.confirm({ select = true }),
      -- (Note: confirm function for blink.cmp is directly integrated,
      -- you usually don't map `confirm` explicitly like `cmp.mapping.confirm`
      -- unless you're customizing beyond the presets. Default preset covers it.)
    },

    -- **Aesthetic Enhancements**
    appearance = {
      -- 'mono' aligns icons for 'Nerd Font Mono' users, 'normal' for 'Nerd Font'.
      -- This helps with the visual alignment and cleanliness of the completion menu.
      nerd_font_variant = 'mono',
      -- You might not need extensive `winhighlight` settings here,
      -- as `blink.cmp` handles much of the menu's aesthetics.
      -- However, if you want specific borders or more control, you could use:
      -- border = 'rounded', -- Add rounded borders to the completion menu
    },

    completion = {
      ghost_text = { enabled = true },
      menu = {
        border = 'rounded',
      },
      -- Documentation can auto-show after a delay for a smoother experience.
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        window = {
          border = 'rounded', -- or 'solid', 'double', etc.
        },
      },
      -- Slightly reduced delay
      -- You can control the `completeopt` behavior here if needed,
      -- but `blink.cmp` aims to handle this intuitively.
    },

    -- **Source Prioritization for Speed & Relevance**
    sources = {
      -- Define the order of sources for relevance and perceived speed.
      -- 'lsp' is typically the fastest and most relevant.
      -- 'snippets' provides quick access to common patterns.
      -- 'path' and 'buffer' are useful but might be slightly slower.
      default = { 'lsp', 'snippets', 'path', 'buffer', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        -- If you want to integrate lspkind for more diverse icons, you might need
        -- a custom formatter. Blink.cmp has good defaults, so this is often not needed.
        -- lsp = {
        --   format = require('lspkind').cmp_format({
        --     mode = 'symbol_text',
        --     maxwidth = 50,
        --     ellipsis_char = '...',
        --   }),
        -- },
      },
    },

    snippets = {
      preset = 'luasnip', -- Tells blink.cmp to use LuaSnip for snippet expansion
    },

    -- **Fuzzy Matching for Speed**
    fuzzy = {
      -- 'prefer_rust_with_warning' will download a prebuilt Rust binary for
      -- faster fuzzy matching. This significantly improves search speed for large lists.
      -- Set to 'lua' if you prefer to avoid the Rust binary.
      implementation = 'prefer_rust_with_warning',
    },

    -- Shows a signature help window, improving context while typing function arguments.
    signature = { enabled = true },
    cmdline = { completion = { ghost_text = { enabled = true } } },

    -- `blink.cmp` automatically handles 'ghost text' functionality,
    -- so you won't find an explicit `ghost_text` option here.
  },
}
