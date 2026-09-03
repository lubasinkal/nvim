vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General
vim.keymap.set('n', ';', ':', { noremap = true, desc = 'Command mode' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })

-- Window focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })

-- Move lines / selections (Alt+j/k)
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

-- <leader>u — UI
vim.keymap.set('n', '<leader>uh', function()
  local enabled = vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(not enabled)
  vim.notify(enabled and 'Inlay hints off' or 'Inlay hints on')
end, { desc = 'Inlay hints' })
vim.keymap.set('n', '<leader>ut', function() require('undotree').open() end, { desc = 'Undo tree' })
vim.keymap.set('n', '<leader>uv', function()
  local current = vim.diagnostic.config().virtual_lines or false
  vim.diagnostic.config { virtual_lines = not current }
end, { desc = 'Diagnostic virtual lines' })

-- <leader>b — buffers
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<CR>', { desc = 'Buffer list' })
vim.keymap.set('n', '<leader>br', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>bl', '<cmd>FzfLua blines<CR>', { desc = 'Buffer lines' })

-- <leader>s — search
vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<CR>', { desc = 'Word under cursor' })
vim.keymap.set('v', '<leader>sw', '<cmd>FzfLua grep_visual<CR>', { desc = 'Visual selection' })
vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })

-- <leader>g — git
vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<CR>', { desc = 'Git files' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Status' })

-- explorer / terminal / quickfix
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Explorer' })
vim.keymap.set('n', '<Leader>tt', function() require('config.util').toggle() end, { desc = 'Toggle floating terminal' })
vim.keymap.set('n', '<leader>q', function()
  local qf_win = vim.fn.getqflist({ winid = 0 }).winid
  if qf_win and qf_win > 0 then vim.cmd 'cclose' else vim.cmd 'copen' end
end, { desc = 'Toggle quickfix' })
