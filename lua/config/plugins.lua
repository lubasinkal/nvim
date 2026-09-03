-- vim.pack setup (nvim 0.12)

-- hooks must be before first vim.pack.add (:h PackChanged)
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('PackHooks', { clear = true }),
  callback = function(ev)
    local data = ev.data or {}
    local name = data.spec and data.spec.name or ''
    local src = data.spec and data.spec.src or ''
    local kind = data.kind or ''
    local is_install = kind == 'install' or kind == 'update'
    if is_install and (name:match 'treesitter' or src:match 'treesitter') then
      pcall(function()
        if not data.active then
          vim.cmd.packadd 'nvim-treesitter'
        end
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

-- deps
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim', -- deprecated, fixes until 2026-06-30
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-mini/mini.icons',
}
require('mini.icons').setup()

-- ui
vim.pack.add { 'https://github.com/scottmckendry/cyberdream.nvim' }
require('cyberdream').setup { transparent = true, italic_comments = true, terminal_colors = true }
vim.cmd 'colorscheme cyberdream'

vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }
require('mini.comment').setup()
require('mini.notify').setup { lsp_progress = { enable = false }, window = { winblend = 100 } }
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.ai').setup { mappings = { around_next = 'aa', inside_next = 'ii' }, n_lines = 500 }
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

-- files
vim.pack.add { 'https://github.com/stevearc/oil.nvim' } -- no lazy-load per README
require('oil').setup { lsp_file_methods = { enabled = false } }
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil (parent directory)' })

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '3' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}
pcall(function()
  require('nvim-web-devicons').setup { default = true }
end)
require('neo-tree').setup { window = { position = 'right', width = 25 } }

-- search
vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
local fzf = require 'fzf-lua'
fzf.setup {
  winopts = {
    width = 0.90,
    height = 0.90,
    preview = { layout = 'horizontal', horizontal = 'right:60%', scrollbar = false, border = 'border' },
  },
  keymap = {
    fzf = { ['ctrl-j'] = 'down', ['ctrl-k'] = 'up', ['ctrl-q'] = 'select-all+accept' },
    builtin = { ['ctrl-c'] = 'close', ['ctrl-x'] = 'jump-accept', ['ctrl-v'] = 'jump', ['ctrl-t'] = 'jump-tab' },
  },
  buffers = { sort_lastused = true, previewer = false, winopts = { height = 0.4, width = 0.6, row = 0.4 } },
  oldfiles = { include_current_session = true },
  lsp = { async_or_timeout = 5000, symbols = { symbol_style = 1 } },
}
fzf.register_ui_select()

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

vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } } -- main=0.12 rewrite, master=0.11 legacy
pcall(function()
  require('nvim-treesitter').setup { install_dir = vim.fn.stdpath 'data' .. '/site' }
end)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterEnable', { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- git
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

-- notes
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

vim.keymap.set('n', '<leader>st', function()
  require('fzf-lua').grep { search = 'TODO|FIXME|HACK|NOTE' }
end, { desc = 'Todo grep' })

-- ai
-- vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
-- require('supermaven-nvim').setup {
--   keymaps = { accept_suggestion = '<C-l>', clear_suggestion = '<C-]>' },
--   ignore_filetypes = { bigfile = true },
--   color = { suggestion_color = '#6c7086', cterm = 244 },
--   log_level = 'off',
--   disable_inline_completion = false,
-- }

-- built-in
vim.cmd.packadd 'nvim.undotree'

-- pack keymaps
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
