return {
  'scottmckendry/cyberdream.nvim',
  event = { 'BufReadPost', 'BufNewFile' }, -- Only load when opening files
  config = function()
    require('cyberdream').setup {
      -- Set light or dark variant
      variant = 'default',

      -- Enable transparent background
      transparent = true,

      -- Reduce the overall saturation of colours for a more muted look
      saturation = 1,

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
    vim.cmd.colorscheme 'cyberdream'

    -- Apply custom highlights after colorscheme loads
    vim.defer_fn(function()
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
    end, 10)
  end,
}
