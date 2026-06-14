return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  cmd = { 'SupermavenUseFree' },
  config = function()
    require('supermaven-nvim').setup({
      keymaps = {
        accept_suggestion = '<C-l>', -- accept ghost text (avoids Tab conflict with blink.cmp)
        clear_suggestion = '<C-]>',  -- dismiss suggestion
      },
      ignore_filetypes = {
        bigfile = true,
      },
      color = {
        suggestion_color = '#6c7086', -- subtle gray that blends with most themes
        cterm = 244,
      },
      log_level = 'off',
      disable_inline_completion = false, -- show ghost text alongside blink.cmp
    })
  end,
}
