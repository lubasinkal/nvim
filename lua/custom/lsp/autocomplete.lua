return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter', -- Load only when entering Insert mode
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build command for LuaSnip's JS regexp support
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets', -- Pre-made snippets
          config = function()
            -- Load VS Code style snippets from friendly-snippets
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      opts = { -- LuaSnip setup options
        -- You can configure LuaSnip here if needed
        -- For example, disable flashing when jumping
        -- store_selection_keys = true,
        -- enable_snipmate_visual_paste = true,
        -- update_events = { "TextChanged", "TextChangedI" },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- nvim-cmp source for LuaSnip
    'onsails/lspkind.nvim', -- Adds icons and descriptions to completion items

    -- Required for `lazydev` source
    -- If you use the lazydev source, uncomment this:
    -- { 'nvim-lazydev/nvim-lazydev', ft = 'lua' },

    -- Completion sources
    'hrsh7th/cmp-nvim-lsp', -- LSP source
    'hrsh7th/cmp-path', -- File system path source
    'hrsh7th/cmp-buffer', -- Current buffer source
    'hrsh7th/cmp-calc', -- Simple math calculator source
    -- 'hrsh7th/cmp-nvim-lsp-signature-help', -- LSP signature help source (optional)
    'hrsh7th/cmp-cmdline', -- Command line source (usually configured separately)

    -- Optional: For specific completion needs
    -- 'hrsh7th/cmp-nvim-lua', -- Neovim Lua API completion
    -- 'petertriho/cmp-git', -- Git commit/branch/tag completion
    -- 'hrsh7th/cmp-treesitter', -- Treesitter based completion
    -- 'hrsh7th/cmp-emoji', -- Emoji completion
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- LuaSnip setup (minimal)
    -- You can add more configuration in the 'opts' table above
    luasnip.config.setup {}

    cmp.setup {
      -- Snippet support
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Use LuaSnip to expand snippets
        end,
      },

      -- Completion behavior
      completion = {
        -- 'menu': show completion menu
        -- 'menuone': show menu if only one completion
        -- 'noinsert': prevent auto-inserting the common prefix
        -- 'noselect': do not auto-select the first item
        -- See `:help completeopt`
        completeopt = 'menu,menuone,noinsert', -- Added 'noselect' as a common preference
      },

      -- Experimental features
      experimental = {
        ghost_text = true, -- Show ghost text preview of the selected completion
        -- native_menu = false, -- Use Neovim's native popupmenu (less configurable styling)
      },

      -- Window appearance
      window = {
        completion = cmp.config.window.bordered {
          border = 'rounded', -- Border style for completion menu
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None', -- Highlighting
          zindex = 1001, -- Ensure window is on top
          scrolloff = 0, -- No scrolloff in the window
          col_offset = 0, -- Column offset
          side_padding = 1, -- Padding
          scrollbar = true, -- Show scrollbar
        },
        documentation = cmp.config.window.bordered {
          border = 'rounded', -- Border style for documentation window
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None', -- Highlighting
          zindex = 1001, -- Ensure window is on top
          scrolloff = 0, -- No scrolloff in the window
          col_offset = 0, -- Column offset
          side_padding = 1, -- Padding
          scrollbar = true, -- Show scrollbar
        },
      },

      -- Keymaps for completion and snippet navigation in Insert mode
      mapping = cmp.mapping.preset.insert {
        -- Select next/previous item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll documentation window
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept currently selected item
        -- See `:help cmp.mapping.confirm()`
        ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Accept with select=true (insert selected text)
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Traditional accept with select=true

        -- Manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Show hover documentation
        -- Mapped in both insert and select modes of cmp
        ['<C-k>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort() -- Abort completion if already visible
          else
            vim.lsp.buf.hover() -- Show hover docs if completion not visible
          end
        end, { 'i', 's' }),

        -- Show signature help
        -- Mapped in both insert and select modes of cmp
        ['<C-s>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort() -- Abort completion if already visible
          else
            vim.lsp.buf.signature_help() -- Show signature help if completion not visible
          end
        end, { 'i', 's' }),

        -- Snippet navigation (expand/jump forward)
        -- Requires `cmp_luasnip` and `LuaSnip`
        -- Check if LuaSnip can expand or jump before calling
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),

        -- Snippet navigation (jump backward)
        -- Requires `cmp_luasnip` and `LuaSnip`
        -- Check if LuaSnip can jump backward before calling
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- Optional: Integrate Tab for completion and snippet jumping
        -- This is a common pattern, but requires careful mapping
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_locally_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
      },

      -- Completion sources and their order/priority
      sources = cmp.config.sources {
        -- {
        --   name = 'lazydev', -- Completion from lazy-loaded plugins (requires nvim-lazydev)
        --   group_index = 0, -- Ensure this source is checked early
        -- },
        { name = 'nvim_lsp', priority = 1000 }, -- LSP server completions
        { name = 'luasnip', priority = 750 }, -- Snippet completions
        -- { name = 'nvim_lsp_signature_help', priority = 700 }, -- Signature help as completion items (optional)
        { name = 'path', priority = 500 }, -- File system path completions
        { name = 'buffer', priority = 300 }, -- Completions from the current buffer
        { name = 'calc', priority = 200 }, -- Calculator results
        { name = 'cmdline', priority = 100 }, -- Command line completion (usually configured separately)
      },

      -- Formatting of completion items using lspkind
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text', -- Show symbol icon and text
          maxwidth = 50, -- Maximum width of completion items
          ellipsis_char = '...', -- Character for truncation
          menu = { -- Text to show next to source name
            buffer = '[buf]',
            nvim_lsp = '[LSP]',
            path = '[path]',
            luasnip = '[snip]',
            calc = '[calc]',
            -- lazydev = '[lazy]',
            cmdline = '[cmd]',
          },
        },
      },

      -- Autocompletion trigger configuration
      -- trigger = { auto_attach = false }, -- Optional: Disable auto-triggering on attach
      -- trigger = { enabled = true, auto_trigger = true}, -- Default behavior
    }
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
          },
        },
      }),
    })
  end,
}
