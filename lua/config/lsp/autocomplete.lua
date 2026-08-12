vim.pack.add {
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/roobert/tailwindcss-colorizer-cmp.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.0' },
}
require('tailwindcss-colorizer-cmp').setup { color_square_width = 2 }
require('blink.cmp').setup {
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
}
