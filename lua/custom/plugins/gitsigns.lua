return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost' },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    -- Enable inline blame
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 500, -- Delay before showing blame
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    -- Keymaps
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Next Hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Prev Hunk' })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk' })
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage Buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset Buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line { full = true }
      end, { desc = 'Blame Line' })
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Blame' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'Diff This' })
      map('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { desc = 'Diff This ~' })
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select Hunk' })
    end,
  },
}
