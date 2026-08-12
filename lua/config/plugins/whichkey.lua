vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  preset = 'helix',
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = {}, -- nerd font glyphs (default) since have_nerd_font is true
  },
  -- Group definitions with icons: shown at the top level of the <leader> popup.
  -- The `desc` of each child mapping gets pattern-matched against which-key's
  -- built-in icon rules (see lua/which-key/icons.lua), so most entries get a
  -- glyph for free (Search/Files/Git/Diagnostics/Session/Toggle/...).
  spec = {
    { '<leader>b', group = 'Buffer', icon = { icon = '󰈔 ', color = 'cyan' } },
    { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'green' } },
    { '<leader>g', group = 'Git', icon = { icon = '󰊢', color = 'orange' } },
    { '<leader>u', group = 'UI / Toggles', icon = { icon = '󰙵 ', color = 'cyan' } },
    { '<leader>w', group = 'Sessions', icon = { icon = '󰉋 ', color = 'azure' } },
    { '<leader>t', group = 'Terminal', icon = { icon = ' ', color = 'red' } },
    { '<leader>e', group = 'Explorer', icon = { icon = '󰉋 ', color = 'blue' } },
    { '<leader>r', group = 'Restart', icon = { icon = '󰜉 ', color = 'purple' } },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' }, icon = { icon = '󰊢', color = 'orange' } },
    { '<leader>p', group = 'Pack', icon = { icon = '󰏗 ', color = 'blue' } },
    { 'gs', group = 'Surround', mode = { 'n', 'x' }, icon = { icon = '󰕘', color = 'yellow' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' }, icon = { icon = '󱧡 ', color = 'orange' } },
  },
}
