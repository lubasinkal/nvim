-- blink.cmp — autocompletion
require('tailwindcss-colorizer-cmp').setup {
    color_square_width = 2,
}

-- blink.cmp v1 pinned to release tag — native library downloads automatically
require('blink.cmp').setup({
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
                if cmp.is_visible() then return cmp.select_next() end
                if cmp.snippet_active() then return cmp.snippet_forward() end
            end,
            'fallback',
        },
        ['<S-Tab>'] = {
            function(cmp)
                if cmp.is_visible() then return cmp.select_prev() end
                if cmp.snippet_active() then return cmp.snippet_backward() end
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
            window = { border = 'rounded' },
        },
    },
})
