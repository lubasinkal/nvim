vim.pack.add {
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/roobert/tailwindcss-colorizer-cmp.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}
require('tailwindcss-colorizer-cmp').setup { color_square_width = 2 }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    ['<C-k>'] = { 'select_next', 'fallback' },
    ['<C-j>'] = { 'select_prev', 'fallback' },
    -- prefer explicit accept key (C-y) to reduce accidental accepts with <CR>
    ['<C-y>'] = { 'accept', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
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
}
