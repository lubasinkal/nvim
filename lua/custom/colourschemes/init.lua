return {
  'nyoom-engineering/oxocarbon.nvim',
  name = 'oxocarbon',
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd 'colorscheme oxocarbon'

    local use_transparency = true -- toggle this to enable/disable transparency
    local hl = vim.api.nvim_set_hl

    if use_transparency then
      -- Use oxocarbon palette for better blending
      local palette = {
        bg = '#161616',
        bg_alt = '#232323',
        fg = '#dde1e6',
        fg_dim = '#a2a9b0',
        border = '#393939',
        accent = '#08bdba',
        menu = '#282828',
        menu_sel = '#262626',
        comment = '#525252',
        purple = '#be95ff',
        blue = '#78a9ff',
        green = '#42be65',
        yellow = '#ffe97b',
        orange = '#ff832b',
        red = '#ee5396',
      }

      local groups = {
        'Normal',
        'NormalNC',
        'NormalFloat',
        'FloatBorder',
        'TelescopeNormal',
        'TelescopeBorder',
        'TelescopePromptNormal',
        'TelescopePromptBorder',
        'TelescopeResultsNormal',
        'TelescopeResultsBorder',
        'NoicePopup',
        'NoicePopupmenu',
        'NoicePopupBorder',
        'Pmenu',
        'PmenuSel',
        'WinSeparator',
        'WhichKeyFloat',
        'CursorLine',
        'StatusLine',
        'StatusLineNC',
      }
      for _, group in ipairs(groups) do
        hl(0, group, { bg = palette.bg, fg = palette.fg })
      end

      -- nvim-cmp highlights (refined for better blending)
      hl(0, 'Pmenu', { bg = palette.bg, fg = palette.fg })
      hl(0, 'PmenuSel', { bg = palette.menu_sel, fg = palette.fg, bold = true })
      hl(0, 'PmenuThumb', { bg = palette.menu_sel })
      hl(0, 'CmpDocumentation', { bg = palette.bg, fg = palette.fg })
      hl(0, 'CmpDocumentationBorder', { bg = palette.bg, fg = palette.border })
      hl(0, 'FloatBorder', { bg = palette.bg, fg = palette.border })
      hl(0, 'CmpBorder', { bg = palette.bg, fg = palette.border })

      -- Source labels
      hl(0, 'CmpItemMenu', { bg = palette.bg, fg = palette.comment })
      hl(0, 'CmpItemMenuDefault', { bg = palette.bg, fg = palette.comment })
      hl(0, 'CmpItemMenuLSP', { bg = palette.bg_alt, fg = palette.blue })
      hl(0, 'CmpItemMenuBuffer', { bg = palette.bg_alt, fg = palette.green })
      hl(0, 'CmpItemMenuSnippet', { bg = palette.bg_alt, fg = palette.yellow })

      -- Completion item matching
      hl(0, 'CmpItemAbbrMatch', { fg = palette.accent, bold = true, bg = palette.bg_alt })
      hl(0, 'CmpItemAbbrMatchFuzzy', { fg = palette.accent, italic = true, bg = palette.bg_alt })
      hl(0, 'CmpSel', { bg = palette.accent, fg = palette.bg, bold = true })

      -- Item kinds
      local kind_groups = {
        Field = palette.orange,
        Function = palette.blue,
        Variable = palette.fg,
        Text = palette.purple,
        Keyword = palette.purple,
        Method = palette.blue,
        Snippet = palette.yellow,
        Constructor = palette.orange,
        Interface = palette.blue,
        Constant = palette.orange,
        Class = palette.blue,
        Module = palette.blue,
        Property = palette.orange,
        Enum = palette.blue,
        EnumMember = palette.blue,
        Struct = palette.blue,
        Reference = palette.red,
        Folder = palette.green,
        File = palette.purple,
        TypeParameter = palette.accent,
        Value = palette.blue,
        Unit = palette.green,
        Event = palette.orange,
        Operator = palette.blue,
      }
      for kind, fg in pairs(kind_groups) do
        hl(0, 'CmpItemKind' .. kind, { fg = fg, bg = 'none' })
      end

      -- UI polish
      hl(0, 'VertSplit', { fg = palette.border, bg = 'none' })
      hl(0, 'LineNr', { fg = palette.comment, bg = 'none' })
    end
  end,
}
