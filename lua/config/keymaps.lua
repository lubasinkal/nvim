vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- -- General (non-leader) keymaps --------------------------------

vim.keymap.set('n', ';', ':', { noremap = true, desc = 'Command mode' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })

-- Window focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })

-- Move lines / selections
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', '<', '<gv', { desc = 'Dedent' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent' })
vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without yank' })

-- <leader>u — UI / toggles
vim.keymap.set('n', '<leader>uh', function()
  local enabled = vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(not enabled)
  vim.notify(enabled and 'Inlay hints off' or 'Inlay hints on')
end, { desc = 'Inlay hints' })
vim.keymap.set('n', '<leader>ut', function()
  require('undotree').open()
end, { desc = 'Undo tree' })
vim.keymap.set('n', '<leader>uv', function()
  local current = vim.diagnostic.config().virtual_lines or false
  vim.diagnostic.config { virtual_lines = not current }
end, { desc = 'Diagnostic virtual lines' })
vim.keymap.set('n', '<leader>un', function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = vim.wo.number
end, { desc = 'Line numbers' })
vim.keymap.set('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Wrap' })
vim.keymap.set('n', '<leader>us', function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = 'Spell check' })
vim.keymap.set('n', '<leader>up', function()
  vim.opt.paste = not vim.opt.paste:get()
end, { desc = 'Paste mode' })
vim.keymap.set('n', '<leader>uf', function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify('Format on save: ' .. (vim.g.format_on_save and 'on' or 'off'))
end, { desc = 'Format on save' })

-- <leader>b — buffers
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New buffer' })
vim.keymap.set('n', '<leader>ba', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<CR>', { desc = 'Buffer list' })
vim.keymap.set('n', '<leader>br', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>bl', '<cmd>FzfLua blines<CR>', { desc = 'Buffer lines' })

-- <leader>s — search
vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>sn', function()
  require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Neovim files' })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>sG', '<cmd>FzfLua grep_project<CR>', { desc = 'Grep (project)' })
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<CR>', { desc = 'Word under cursor' })
vim.keymap.set('v', '<leader>sw', '<cmd>FzfLua grep_visual<CR>', { desc = 'Visual selection' })
vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sr', '<cmd>FzfLua resume<CR>', { desc = 'Resume last' })
vim.keymap.set('n', '<leader>s.', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>sJ', '<cmd>FzfLua jumps<CR>', { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sm', '<cmd>FzfLua marks<CR>', { desc = 'Marks' })

-- <leader>g — git
vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<CR>', { desc = 'Git files' })
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { desc = 'Commits' })
vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Branches' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Status' })
vim.keymap.set('n', '<leader>gS', '<cmd>FzfLua git_stash<CR>', { desc = 'Stash' })
vim.keymap.set('n', '<leader>gD', function()
  require('gitsigns').diffthis()
end, { desc = 'Diff (working tree)' })
vim.keymap.set('n', '<leader>gB', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Blame line' })

-- <leader>e — explorer / files
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Explorer' })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Oil (parent dir)' })

-- <leader>t — terminal
vim.keymap.set('n', '<Leader>tt', function()
  require('config.util.floaterminal').toggle()
end, { desc = 'Toggle floating terminal' })

-- <leader>w — sessions
vim.keymap.set('n', '<leader>ws', function()
  require('mini.sessions').write(vim.fs.basename(vim.uv.cwd()) .. '.vim')
end, { desc = 'Save session' })
vim.keymap.set('n', '<leader>wl', function()
  require('mini.sessions').read(vim.fs.basename(vim.uv.cwd()) .. '.vim')
end, { desc = 'Load session' })
vim.keymap.set('n', '<leader>wd', function()
  require('mini.sessions').delete(vim.fs.basename(vim.uv.cwd()) .. '.vim')
end, { desc = 'Delete session' })
vim.keymap.set('n', '<leader>wL', function()
  require('mini.sessions').select 'read'
end, { desc = 'List sessions' })

-- <leader>q — quickfix toggle
vim.keymap.set('n', '<leader>q', function()
  local qf_win = vim.fn.getqflist({ winid = 0 }).winid
  if qf_win and qf_win > 0 then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end, { desc = 'Toggle quickfix' })
-- <leader>r — restart / reload
vim.keymap.set('n', '<leader>re', function()
  require('mini.sessions').write(vim.fs.basename(vim.uv.cwd()) .. '.vim')
  vim.cmd [[restart lua pcall(require('mini.sessions').read)]]
end, { desc = 'Restart nvim' })
vim.keymap.set('n', '<leader>rl', function()
  pcall(vim.cmd.luafile, vim.fn.stdpath 'config' .. '/init.lua')
  vim.notify 'Config reloaded'
end, { desc = 'Reload config' })
