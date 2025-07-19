return {
  'scottmckendry/cyberdream.nvim',
  lazy = false, -- Load during startup
  priority = 1000, -- Load this before other plugins
  config = function()
    require('cyberdream').setup {
      -- Set light or dark variant
      variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

      -- Enable transparent background
      transparent = true,

      -- Reduce the overall saturation of colours for a more muted look
      saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

      -- Enable italics comments
      italic_comments = true,

      -- Replace all fillchars with ' ' for the ultimate clean look
      hide_fillchars = true,

      -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
      borderless_pickers = false,

      -- Set terminal colors used in `:terminal`
      terminal_colors = true,

      -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
      cache = true,
    }
    -- Set the colorscheme
    -- vim.cmd 'colorscheme vesper'
    vim.cmd 'colorscheme cyberdream'
    -- Transparency for syntax elements
    local transparent_groups = {
      'Normal',
      'NormalNC',
      'NormalFloat',
      'SignColumn',
      'CursorLine',
      'CursorLineNr',
      'StatusLine',
      'StatusLineNC',
      'EndOfBuffer',
      'VertSplit',
      'BufferLineFill',
      'BufferLineBackground',
      'NeoTreeNormal',
      'NeoTreeNormalNC',
      'NeoTreeEndOfBuffer',
      'WhichKeyFloat',
      'WhichKey',
      'WhichKeyBorder',
      'WhichKeyTitle',
      'WhichKeyNormal',
    }

    for _, hl in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, hl, { bg = 'none' })
    end

    -- UI Elements only (no syntax highlighting as TreeSitter handles that)
    local ui_highlights = {

      -- CMP
      CmpSel = { bg = '#313131', fg = '#ffffff' },
      CmpItemAbbr = { fg = '#ffffff' },
      CmpItemAbbrDeprecated = { fg = '#cccccc', strikethrough = true },
      CmpItemAbbrMatch = { fg = '#82d9c2', bold = true },
      CmpItemAbbrMatchFuzzy = { fg = '#82d9c2', bold = true },
      CmpItemMenu = { fg = '#ffffff' },
      CmpGhostText = { fg = '#82d777', bg = 'none' },
    }

    -- Apply UI highlights
    for group, opts in pairs(ui_highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
}
