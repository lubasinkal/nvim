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
                    -- If there's a word before cursor, trigger completion
                    local col = vim.fn.col('.') - 1
                    if col > 0 and vim.fn.getline('.'):sub(col, col):match('%w') then
                        cmp.complete()
                        return cmp.select_next()
                    end
                    return cmp.fallback()
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
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CmpSel',
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
                                local icon = ctx.kind_icon or ''

                                local ok, lspkind = pcall(require, 'lspkind')
                                if ok and lspkind then
                                    local sym

                                    -- common layout: symbolic is a table mapping kinds -> icons
                                    if type(lspkind.symbolic) == 'table' then
                                        sym = lspkind.symbolic[ctx.kind]
                                    end

                                    -- some versions expose a function; try calling it safely
                                    if not sym and type(lspkind.symbolic) == 'function' then
                                        local ok1, res1 = pcall(lspkind.symbolic, ctx.kind)
                                        if ok1 then
                                            if type(res1) == 'string' then
                                                sym = res1
                                            elseif type(res1) == 'table' then
                                                sym = res1[ctx.kind] or res1
                                            end
                                        end
                                    end

                                    -- fallback: symbol_map or symbols/table-like presets
                                    if not sym and type(lspkind.symbol_map) == 'table' then
                                        sym = lspkind.symbol_map[ctx.kind]
                                    end
                                    if not sym and type(lspkind.presets) == 'table' and type(lspkind.presets.default) == 'table' then
                                        sym = lspkind.presets.default[ctx.kind]
                                    end

                                    if sym and type(sym) == 'string' and #sym > 0 then
                                        icon = sym
                                    end
                                end

                                return (icon or '') .. ' '
                            end,
                        },
                    },
                },
            },

            -- documentation popup
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = {
                    border = 'rounded',
                    max_width = 80,
                    max_height = 15,
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
