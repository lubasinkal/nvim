return {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        {
            'rafamadriz/friendly-snippets',
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
        },
        signature = { enabled = true },
        completion = {
            accept = {
                auto_brackets = { enabled = true },
            },
            documentation = {
                auto_show = true,
                window = {
                    border = 'rounded',
                },
            },
        },
    },
}
