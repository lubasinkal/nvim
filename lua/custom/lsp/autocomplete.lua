return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
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

    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',
            ['<C-k>'] = { 'select_next', 'fallback' },
            ['<C-j>'] = { 'select_prev', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            -- prefer explicit accept key (C-y) to reduce accidental accepts with <CR>
            ['<C-y>'] = { 'accept', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },
            ['<C-e>'] = { 'cancel', 'fallback' },
            ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            -- Tab / S-Tab: sensible fallbacks, snippet support, complete when appropriate
            ['<Tab>'] = {
                function(cmp)
                    -- If popup visible, select next
                    if cmp.is_visible() then
                        return cmp.select_next()
                    end
                    -- If snippet engine has jump available, jump
                    if cmp.snippet_active() then
                        return cmp.snippet_forward()
                    end
                end,
                'fallback',
            },

            ['<S-Tab>'] = {
                function(cmp)
                    if cmp.is_visible() then
                        return cmp.select_prev()
                    end
                    if cmp.snippet_active() then
                        return cmp.snippet_backward()
                    end
                    return cmp.fallback()
                end,
                'fallback',
            },
        },

        appearance = {
            nerd_font_variant = 'mono',
            -- optional small lspkind integration: will fall back to kind_icon if lspkind not available
        },

        -- Sources: prioritise LSP & snippets, deprioritise buffer; small offsets tune ranking
        sources = {
            default = { 'lsp', 'snippets', 'path', 'buffer' },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                lsp = { score_offset = 80, min_keyword_length = 1 },
                snippets = { score_offset = 90, min_keyword_length = 1 },
                path = { score_offset = 50, min_keyword_length = 1 },
                buffer = {
                    score_offset = 10,
                    min_keyword_length = 3,
                },
            },
        },

        -- keep your snippet preset
        snippets = { preset = 'luasnip' },

        signature = { enabled = true },

        -- completion-specific settings
        completion = {

            accept = {
                auto_brackets = { enabled = true },
            },

            -- menu rendering and components
            menu = {
                border = 'rounded',
                draw = {
                    padding = 1,
                    gap = 1,
                    treesitter = { 'lsp' },
                    columns = {
                        { 'kind_icon' },
                        { 'label',      'label_description', gap = 1 },
                        { 'source_name' },
                    },
                    components = {
                        source_name = {
                            text = function(ctx)
                                local source_display_names = {
                                    lsp = '[lsp]',
                                    path = '[path]',
                                    snippets = '[snip]',
                                    buffer = '[buf]',
                                }
                                return source_display_names[ctx.source_name] or string.format('[%s]', ctx.source_name)
                            end,
                        },
                        kind_icon = {
                            text = function(ctx) return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' ' end
                        }
                    },
                },
            },

            -- documentation popup
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = {
                    border = 'rounded',
                },
            },

            -- ghost text: visible but subtle
            ghost_text = {
                enabled = true,
            },


        },

        -- allow people to extend these defaults without copy-pasting everything
        -- opts_extend will merge 'sources.default' from above
    },
    opts_extend = { 'sources.default' },
}
