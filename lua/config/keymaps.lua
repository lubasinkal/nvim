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

-- Move lines / selections (Alt+j/k)
-- <A-j> and <M-j> are synonyms in nvim, mapping both for terminal compat
local function move_opts(desc) return { desc = desc, silent = true } end
vim.keymap.set('n', '<A-j>', '<Cmd>silent! m .+1<CR>==', move_opts 'Move line down')
vim.keymap.set('n', '<A-k>', '<Cmd>silent! m .-2<CR>==', move_opts 'Move line up')
vim.keymap.set('n', '<M-j>', '<Cmd>silent! m .+1<CR>==', move_opts 'Move line down')
vim.keymap.set('n', '<M-k>', '<Cmd>silent! m .-2<CR>==', move_opts 'Move line up')
vim.keymap.set('v', '<A-j>', ":silent! m '>+1<CR>gv=gv", move_opts 'Move selection down')
vim.keymap.set('v', '<A-k>', ":silent! m '<-2<CR>gv=gv", move_opts 'Move selection up')
vim.keymap.set('v', '<M-j>', ":silent! m '>+1<CR>gv=gv", move_opts 'Move selection down')
vim.keymap.set('v', '<M-k>', ":silent! m '<-2<CR>gv=gv", move_opts 'Move selection up')
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

-- <leader>b — buffers (mini.pick)
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New buffer' })
vim.keymap.set('n', '<leader>ba', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bb', function() require('mini.pick').builtin.buffers() end, { desc = 'Buffer list' })
vim.keymap.set('n', '<leader>br', function() require('mini.extra').pickers.oldfiles() end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>bl', function() require('mini.extra').pickers.buf_lines() end, { desc = 'Buffer lines' })

-- <leader>s — search (fff for files/grep, mini.pick for rest)
vim.keymap.set('n', '<leader>sf', function() require('fff').find_files() end, { desc = 'Files' })
vim.keymap.set('n', '<leader>sn', function() require('fff').find_files_in_dir(vim.fn.stdpath 'config') end, { desc = 'Neovim files' })
vim.keymap.set('n', '<leader>sg', function() require('fff').live_grep() end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sG', function() require('fff').live_grep() end, { desc = 'Grep (project)' })
vim.keymap.set('n', '<leader>sw', function() require('fff').live_grep_under_cursor() end, { desc = 'Word under cursor' })
vim.keymap.set('x', '<leader>sw', function() require('fff').live_grep_under_cursor() end, { desc = 'Visual selection' })
vim.keymap.set('n', '<leader>sd', function() require('mini.extra').pickers.diagnostic() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sh', function() require('mini.pick').builtin.help() end, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>sk', function() require('mini.extra').pickers.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sr', function() require('mini.pick').builtin.resume() end, { desc = 'Resume last' })
vim.keymap.set('n', '<leader>s.', function() require('mini.extra').pickers.oldfiles() end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>sJ', function()
  local ok = pcall(require('mini.extra').pickers.list, { scope = 'jump' })
  if not ok then vim.cmd.jumps() end
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sm', function() require('mini.extra').pickers.marks() end, { desc = 'Marks' })

-- <leader>g — git (mini.extra)
vim.keymap.set('n', '<leader>gf', function() require('mini.extra').pickers.git_files() end, { desc = 'Git files' })
vim.keymap.set('n', '<leader>gc', function() require('mini.extra').pickers.git_commits() end, { desc = 'Commits' })
vim.keymap.set('n', '<leader>gb', function() require('mini.extra').pickers.git_branches() end, { desc = 'Branches' })
vim.keymap.set('n', '<leader>gs', function() require('mini.extra').pickers.git_hunks() end, { desc = 'Status (hunks)' })
vim.keymap.set('n', '<leader>gS', function() require('mini.pick').builtin.cli { command = { 'git', 'stash', 'list' } } end, { desc = 'Stash' })
vim.keymap.set('n', '<leader>gD', function()
  require('gitsigns').diffthis()
end, { desc = 'Diff (working tree)' })
vim.keymap.set('n', '<leader>gB', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Blame line' })

-- <leader>e — explorer / files (Oil '-' is set in plugins.lua)
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Explorer' })

-- <leader>t — terminal
vim.keymap.set('n', '<Leader>tt', function()
  require('config.util').toggle()
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
