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
