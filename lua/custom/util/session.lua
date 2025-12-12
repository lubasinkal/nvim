local M = {}

-- Simple Session Management

local function get_session_name()
  if vim.fn.trim(vim.fn.system('git rev-parse --is-inside-work-tree 2> /dev/null')) == 'true' then
    local git_root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    local branch_name = vim.fn.trim(vim.fn.system('git branch --show-current'))
    return (git_root .. '_' .. branch_name):gsub('[\\/:]+', '_') .. '.vim'
  else
    return 'Session.vim'
  end
end

-- We will just use standard Session.vim in CWD for simplicity, mimicking auto-session default somewhat,
-- but sticking to the user's specific manual save/restore workflow.
local session_file = 'Session.vim'

function M.save_session()
  vim.cmd('mksession! ' .. session_file)
  vim.notify('Session saved to ' .. session_file, vim.log.levels.INFO)
end

function M.restore_session()
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd('source ' .. session_file)
    vim.notify('Session restored from ' .. session_file, vim.log.levels.INFO)
  else
    vim.notify('No session file found: ' .. session_file, vim.log.levels.WARN)
  end
end

-- Commands
vim.api.nvim_create_user_command('SessionSave', M.save_session, {})
vim.api.nvim_create_user_command('SessionRestore', M.restore_session, {})

-- Keymaps
vim.keymap.set('n', '<leader>wr', M.restore_session, { desc = 'Session Restore' })
vim.keymap.set('n', '<leader>ws', M.save_session, { desc = 'Save session' })

return M
