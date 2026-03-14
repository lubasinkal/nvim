-- Mini.nvim modular plugins loaded on VeryLazy event for smooth startup
return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    require('mini.comment').setup()
    require('mini.notify').setup {
      lsp_progress = { enable = false },
      -- Window options
      window = {
        winblend = 100,
      },
    }
    require('mini.indentscope').setup()
    require('mini.pairs').setup()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        --e.g. gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        --e.g. gsaa}) - [S]urround [A]dd [A]round [}]Braces [)]Paren
        delete = 'gsd', -- Delete surrounding
        --e.g.    gsd"   - [S]urround [D]elete ["]quotes
        replace = 'gsr', -- Replace surrounding
        --e.g.     gsr)'  - [S]urround [R]eplace [)]Paren by [']quote
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
      n_lines = 500,
    }
  end,
}
