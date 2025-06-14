return {
  'datsfilipe/vesper.nvim',
  lazy = false, -- Load during startup
  priority = 1000, -- Load this before other plugins
  config = function()
    require('vesper').setup {
      transparent = true, -- Boolean: Sets the background to transparent
      italics = {
        comments = true, -- Boolean: Italicizes comments
        keywords = true, -- Boolean: Italicizes keywords
        functions = true, -- Boolean: Italicizes functions
        strings = true, -- Boolean: Italicizes strings
        variables = true, -- Boolean: Italicizes variables
      },
      overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
      palette_overrides = {},
    }
    -- Set the colorscheme
    vim.cmd 'colorscheme vesper'

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
      "BufferLineFill",
      'BufferLineBackground',
      'NeoTreeNormal',
      'NeoTreeNormalNC',
      'NeoTreeEndOfBuffer',
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
