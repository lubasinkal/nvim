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
        hl(0, group, { bg = 'none' })
      end

      -- nvim-cmp highlights
      hl(0, 'Pmenu', { bg = 'none', fg = '#c0caf5' })
      hl(0, 'PmenuSel', { bg = '#3b4261', fg = '#ffffff', bold = true })
      hl(0, 'PmenuThumb', { bg = '#3b4261' })
      hl(0, 'CmpDocumentation', { bg = 'none' })
      hl(0, 'CmpDocumentationBorder', { bg = 'none', fg = '#3b4261' })
      hl(0, 'FloatBorder', { bg = 'none', fg = '#3b4261' })
      hl(0, 'CmpBorder', { bg = 'none', fg = '#3b4261' })

      -- Source labels
      hl(0, 'CmpItemMenu', { bg = 'none', fg = '#7f849c' })
      hl(0, 'CmpItemMenuDefault', { bg = 'none', fg = '#7f849c' })
      hl(0, 'CmpItemMenuLSP', { bg = 'none', fg = '#7aa2f7' })
      hl(0, 'CmpItemMenuBuffer', { bg = 'none', fg = '#9ece6a' })
      hl(0, 'CmpItemMenuSnippet', { bg = 'none', fg = '#e0af68' })

      -- Completion item matching
      hl(0, 'CmpItemAbbrMatch', { fg = '#7dcfff', bold = true })
      hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#7dcfff', italic = true })
      hl(0, 'CmpSel', { bg = '#7a388b', fg = '#ffffff', bold = true })

      -- Item kinds
      local kind_groups = {
        Field = '#ff9e64',
        Function = '#7aa2f7',
        Variable = '#c0caf5',
        Text = '#9d7cd8',
        Keyword = '#bb9af7',
        Method = '#82cfff',
        Snippet = '#e0af68',
        Constructor = '#ff7eb6',
        Interface = '#7dcfff',
        Constant = '#ff7eb6',
        Class = '#33b1ff',
        Module = '#33b1ff',
        Property = '#ff7eb6',
        Enum = '#78a9ff',
        EnumMember = '#82cfff',
        Struct = '#33b1ff',
        Reference = '#ee5396',
        Folder = '#42be65',
        File = '#be95ff',
        TypeParameter = '#3ddbd9',
        Value = '#82cfff',
        Unit = '#42be65',
        Event = '#ff7eb6',
        Operator = '#33b1ff',
      }

      for kind, fg in pairs(kind_groups) do
        hl(0, 'CmpItemKind' .. kind, { fg = fg, bg = 'none' })
      end

      -- UI polish
      hl(0, 'VertSplit', { fg = '#3B3B3B', bg = 'none' })
      hl(0, 'LineNr', { fg = '#5c5c5c', bg = 'none' })
    end
  end,
}
