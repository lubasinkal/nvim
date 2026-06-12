local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'
local session_dir_ready = false

local function ensure_session_dir()
  if not session_dir_ready then
    session_dir_ready = true
    if not vim.uv.fs_stat(session_dir) then
      vim.uv.fs_mkdir(session_dir, tonumber('755', 8))
    end
  end
end

local function escape_path(path)
  return path:gsub([[][{}*?`'\% !#]], [[\%0]])
end

local function get_session_filename()
  local name = vim.fs.basename(vim.uv.cwd())
  local branch = vim.b.gitsigns_head
  if branch and branch ~= 'main' and branch ~= 'master' then
    name = name .. '%%' .. branch
  end
  return session_dir .. name .. '.vim'
end

function M.branch()
  return vim.b.gitsigns_head
end

function M.save()
  ensure_session_dir()
  local path = get_session_filename()
  vim.cmd('mksession! ' .. escape_path(path))
  vim.notify('Session saved ' .. path:sub(#session_dir + 1), vim.log.levels.INFO)
end

function M.load()
  local cwd_name = vim.fs.basename(vim.uv.cwd())
  local branch = vim.b.gitsigns_head
  local has_branch = branch and branch ~= 'main' and branch ~= 'master'

  local base_path = session_dir .. cwd_name .. '.vim'

  if has_branch then
    local branch_path = session_dir .. cwd_name .. '%%' .. branch .. '.vim'
    if vim.uv.fs_stat(branch_path) then
      vim.cmd('source ' .. escape_path(branch_path))
      vim.notify('Session loaded', vim.log.levels.INFO)
      return
    end
  end

  if vim.uv.fs_stat(base_path) then
    vim.cmd('source ' .. escape_path(base_path))
    vim.notify(has_branch and 'Session loaded (no branch)' or 'Session loaded', vim.log.levels.INFO)
    return
  end

  vim.notify('No session found', vim.log.levels.WARN)
end

function M.delete()
  local path = get_session_filename()
  if vim.uv.fs_stat(path) then
    vim.uv.fs_unlink(path)
    vim.notify('Session deleted', vim.log.levels.INFO)
  else
    vim.notify('No session to delete', vim.log.levels.WARN)
  end
end

function M.list()
  local files = {}
  for name, type in vim.fs.dir(session_dir) do
    if type == 'file' and name:match '%.vim$' then
      table.insert(files, {
        path = session_dir .. name,
        name = name:gsub('%.vim$', ''),
      })
    end
  end

  if #files == 0 then
    vim.notify('No saved sessions', vim.log.levels.WARN)
    return
  end

  table.sort(files, function(a, b)
    return a.name < b.name
  end)

  vim.ui.select(files, {
    prompt = 'Sessions (Enter=load, d=delete):',
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.ui.select({ 'load', 'delete' }, {
      prompt = 'Action:',
    }, function(action)
      if action == 'load' then
        vim.cmd('source ' .. escape_path(choice.path))
        vim.notify('Loaded: ' .. choice.name, vim.log.levels.INFO)
      else
        vim.uv.fs_unlink(choice.path)
        vim.notify('Deleted: ' .. choice.name, vim.log.levels.INFO)
      end
    end)
  end)
end

vim.api.nvim_create_user_command('SessionSave', M.save, {})
vim.api.nvim_create_user_command('SessionLoad', M.load, {})
vim.api.nvim_create_user_command('SessionDelete', M.delete, {})
vim.api.nvim_create_user_command('SessionList', M.list, {})

vim.keymap.set('n', '<leader>ws', M.save, { desc = 'Save session' })
vim.keymap.set('n', '<leader>wl', M.load, { desc = 'Load current' })
vim.keymap.set('n', '<leader>wd', M.delete, { desc = 'Delete current' })
vim.keymap.set('n', '<leader>wL', M.list, { desc = 'List sessions' })

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return M
