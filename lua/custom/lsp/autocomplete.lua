return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    'rafamadriz/friendly-snippets',
    -- optional: provides icon support
    'onsails/lspkind.nvim',
    -- optional: tailwind css colorizer
    {
      'roobert/tailwindcss-colorizer-cmp.nvim',
      config = function()
        require('tailwindcss-colorizer-cmp').setup {
          color_square_width = 2,
        }
      end,
    },
  },

  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- and build your own keymap.
    keymap = {
      preset = 'default',
      ['<C-k>'] = { 'select_next', 'fallback' },
      ['<C-j>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-y>'] = { 'accept', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_next()
          elseif cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.fallback()
          end
        end,
        'fallback',
      },
      ['<S-Tab>'] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_prev()
          elseif cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.fallback()
          end
        end,
        'fallback',
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing and ensures icons are aligned
      nerd_font_variant = 'mono',
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    snippets = { preset = 'luasnip' },
    -- experimental signature help support
    signature = { enabled = true },

    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = 'rounded',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CmpSel',
        -- Controls how the completion items are rendered on the popup window
        draw = {
          -- Left and right padding, optionally { left, right } for different padding on each side
          padding = 1,
          -- Gap between columns
          gap = 1,
          -- Use treesitter to highlight the label
          treesitter = { 'lsp' },
          -- Components to render, grouped by column
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
          -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
          components = {
            source_name = {
              text = function(ctx)
                local source_display_names = {
                  lsp = '[LSP]',
                  path = '[path]',
                  snippets = '[snip]',
                  buffer = '[buf]',
                }
                return source_display_names[ctx.source_name] or string.format('[%s]', ctx.source_name)
              end,
            },
            kind_icon = {
              text = function(ctx)
                local kind_icon = ctx.kind_icon
                return kind_icon .. ' '
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'rounded',
          max_width = 80,
          max_height = 15,
        },
      },
      ghost_text = {
        enabled = true,
      },
    },
  },
  opts_extend = { 'sources.default' },
}
