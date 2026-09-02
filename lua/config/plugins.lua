-- Consolidated plugins: all vim.pack.add + setup in one place.
-- Sections are folded via -- stylua: ignore / region comments for navigation.

-- ── Dependencies ──────────────────────────────────────────────────────────
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-mini/mini.icons',
}
require('mini.icons').setup()

-- Keep treesitter parsers fresh on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('PackHooks', { clear = true }),
  callback = function(ev)
    if ev.data.kind ~= 'update' and ev.data.kind ~= 'install' then
      return
    end
    local spec = ev.data.spec or {}
    local is_treesitter = (spec.name or ''):match 'treesitter' or (spec.src or ''):match 'treesitter'
    if is_treesitter then
      pcall(function()
        vim.cmd.packadd 'nvim-treesitter'
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

-- ── UI ──────────────────────────────────────────────────────────────────
-- colorscheme
vim.pack.add { 'https://github.com/scottmckendry/cyberdream.nvim' }
require('cyberdream').setup {
  transparent = true,
  italic_comments = true,
  terminal_colors = true,
}
vim.cmd 'colorscheme cyberdream'

-- mini.nvim (comment, notify, indentscope, pairs, ai, surround, statusline, tabline, sessions)
vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }
require('mini.comment').setup()
require('mini.notify').setup {
  lsp_progress = { enable = false },
  window = { winblend = 100 },
}
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.ai').setup {
  mappings = { around_next = 'aa', inside_next = 'ii' },
  n_lines = 500,
}
require('mini.surround').setup {
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    replace = 'gsr',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    update_n_lines = 'gsn',
  },
  n_lines = 500,
}
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end
require('mini.tabline').setup()
vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })
require('mini.sessions').setup {
  directory = vim.fn.stdpath 'data' .. '/sessions/',
  file = '',
  force = { read = true, write = true, delete = true },
  verbose = { write = true, delete = true },
}
require('mini.pick').setup()
require('mini.extra').setup()
vim.ui.select = require('mini.pick').ui_select

-- which-key
vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  preset = 'helix',
  icons = { mappings = vim.g.have_nerd_font, keys = {} },
  spec = {
    { '<leader>b', group = 'Buffer', icon = { icon = '󰈔 ', color = 'cyan' } },
    { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'green' } },
    { '<leader>g', group = 'Git', icon = { icon = '󰊢', color = 'orange' } },
    { '<leader>u', group = 'UI / Toggles', icon = { icon = '󰙵 ', color = 'cyan' } },
    { '<leader>w', group = 'Sessions', icon = { icon = '󰉋 ', color = 'azure' } },
    { '<leader>t', group = 'Terminal', icon = { icon = ' ', color = 'red' } },
    { '<leader>e', group = 'Explorer', icon = { icon = '󰉋 ', color = 'blue' } },
    { '<leader>r', group = 'Restart', icon = { icon = '󰜉 ', color = 'purple' } },
    { '<leader>q', group = 'Quickfix', icon = { icon = '󰅚 ', color = 'orange' } },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' }, icon = { icon = '󰊢', color = 'orange' } },
    { '<leader>p', group = 'Pack', icon = { icon = '󰏗 ', color = 'blue' } },
    { 'gs', group = 'Surround', mode = { 'n', 'x' }, icon = { icon = '󰕘', color = 'yellow' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' }, icon = { icon = '󱧡 ', color = 'orange' } },
  },
}

-- ── Files / Explorer ────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup { lsp_file_methods = { enabled = false } }
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil (parent directory)' })

vim.pack.add { { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' } }
require('neo-tree').setup { window = { position = 'right', width = 25 } }

-- ── Navigation / Search ─────────────────────────────────────────────────
vim.pack.add { 'https://github.com/dmtrKovalenko/fff' }
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'fff'
      end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}

vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('flash').setup()
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

-- ── Git ─────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = { ignore_whitespace = false },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
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
    map('n', ']H', function()
      gs.nav_hunk 'last'
    end, { desc = 'Last Hunk' })
    map('n', '[H', function()
      gs.nav_hunk 'first'
    end, { desc = 'First Hunk' })
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk' })
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
    map('n', '<leader>ub', gs.toggle_current_line_blame, { desc = 'Blame' })
  end,
}

-- ── Formatting ──────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff', 'black' },
    javascript = { 'biome', 'prettier' },
    typescript = { 'biome', 'prettier' },
    javascriptreact = { 'biome', 'prettier' },
    typescriptreact = { 'biome', 'prettier' },
    css = { 'biome', 'prettier' },
    html = { 'biome', 'prettier' },
    json = { 'biome', 'prettier' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    go = { 'gofumpt', 'gofmt' },
    rust = { 'rustfmt' },
  },
  format_on_save = function()
    if vim.g.format_on_save == false then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}

-- ── Notes / Markdown / Typst ────────────────────────────────────────────
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {}

vim.pack.add { 'https://github.com/chomosuke/typst-preview.nvim' }
require('typst-preview').setup { port = 6767 }
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function(event)
    vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreviewToggle<cr>', { buffer = event.buf, desc = 'Toggle Typst Preview' })
  end,
})

vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup {}
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })
vim.keymap.set('n', '<leader>st', '<cmd>TodoQuickFix<cr>', { desc = 'Todo Comments' })

-- ── AI ──────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
require('supermaven-nvim').setup {
  keymaps = { accept_suggestion = '<C-l>', clear_suggestion = '<C-]>' },
  ignore_filetypes = { bigfile = true },
  color = { suggestion_color = '#6c7086', cterm = 244 },
  log_level = 'off',
  disable_inline_completion = false,
}

-- ── Built-in pack: undotree (nvim 0.12) ─────────────────────────────────
vim.cmd.packadd 'nvim.undotree'

-- ── Pack management keymaps ─────────────────────────────────────────────
vim.keymap.set('n', '<leader>pu', function()
  vim.pack.update()
end, { desc = 'Update plugins' })
vim.keymap.set('n', '<leader>pU', function()
  vim.pack.update(nil, { force = true })
end, { desc = 'Update plugins (force)' })
vim.keymap.set('n', '<leader>pl', function()
  local lines = {}
  for _, p in ipairs(vim.pack.get()) do
    lines[#lines + 1] = string.format('%s %s', p.active and '✓' or ' ', p.spec and p.spec.name or '?')
  end
  table.sort(lines)
  vim.notify('Installed plugins:\n' .. table.concat(lines, '\n'))
end, { desc = 'List plugins' })
