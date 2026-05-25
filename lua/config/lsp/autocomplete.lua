vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },
})

vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' })
vim.pack.add({ 'https://github.com/roobert/tailwindcss-colorizer-cmp.nvim' })

require('tailwindcss-colorizer-cmp').setup { color_square_width = 2 }

require('blink.cmp').setup({
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    signature = { enabled = true },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, window = { border = 'rounded' } },
    },
})
