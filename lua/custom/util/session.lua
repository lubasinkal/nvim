local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'
local esc = vim.fn.fnameescape

-- Ensure session directory exists
local function ensure_session_dir()
  if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, 'p')
  end
end

local function get_session_filename()
  local cwd = vim.uv.cwd()
  local name = cwd:gsub('[/\\:]+', '_')

  -- Git-aware naming
  local git_dir_stat = vim.uv.fs_stat(vim.fs.joinpath(cwd, '.git'))
  if git_dir_stat and git_dir_stat.type == 'directory' then
    local git_root = vim.fn.trim(vim.fn.system 'git rev-parse --show-toplevel 2>/dev/null')
    if vim.v.shell_error == 0 and git_root and git_root ~= '' then
      name = git_root:gsub('[/\\:]+', '_')
      local branch = vim.fn.trim(vim.fn.system 'git branch --show-current 2>/dev/null')
      if vim.v.shell_error == 0 and branch and branch ~= '' and branch ~= 'main' and branch ~= 'master' then
        name = name .. '%%' .. branch:gsub('[/\\:]+', '_')
      end
    end
  end

  return session_dir .. name .. '.vim'
end

function M.save()
  ensure_session_dir()
  local path = get_session_filename()
  vim.cmd('mksession! ' .. esc(path))
  vim.notify('Session saved → ' .. vim.fn.fnamemodify(path, ':~'), vim.log.levels.INFO)
end

function M.load()
  ensure_session_dir()
  local path = get_session_filename()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. esc(path))
    vim.notify('Session loaded', vim.log.levels.INFO)
  else
    vim.notify('No session found for current project/branch', vim.log.levels.WARN)
  end
end

function M.delete_current()
  local path = get_session_filename()
  if vim.fn.filereadable(path) == 1 then
    vim.fn.delete(path)
    vim.notify('Deleted session: ' .. vim.fn.fnamemodify(path, ':t'), vim.log.levels.INFO)
  else
    vim.notify('No session exists for current project', vim.log.levels.WARN)
  end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Telescope integration
-- ──────────────────────────────────────────────────────────────────────────────

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local function telescope_sessions(opts)
  opts = opts or {}
  ensure_session_dir()

  local files = vim.fn.glob(session_dir .. '*.vim', false, true)
  if #files == 0 then
    vim.notify('No saved sessions found', vim.log.levels.WARN)
    return
  end

  local entries = {}
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ':t:r') -- filename without .vim
    local display = name:gsub('%%', ' on branch ') -- nicer display
    table.insert(entries, {
      value = file,
      display = display,
      ordinal = name,
      path = file,
    })
  end

  pickers
    .new(opts, {
      prompt_title = 'Sessions',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.ordinal,
            filename = entry.path,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        local load_session = function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection and selection.value and selection.value.path then
            vim.cmd('source ' .. esc(selection.value.path))
            vim.notify('Loaded session: ' .. selection.display, vim.log.levels.INFO)
          end
        end

        local delete_session = function()
          local selection = action_state.get_selected_entry()
          if selection and selection.value and selection.value.path then
            local confirm = vim.fn.input("Delete '" .. selection.display .. "'? (y/n): ")
            if confirm:lower() == 'y' or confirm:lower() == 'yes' then
              vim.fn.delete(selection.value.path)
              vim.notify('Deleted: ' .. selection.display, vim.log.levels.INFO)
              -- Refresh picker
              actions.close(prompt_bufnr)
              telescope_sessions(opts)
            end
          end
        end

        -- Default action = load
        actions.select_default:replace(load_session)

        -- <C-d> or custom key to delete
        map('i', '<C-d>', delete_session)
        map('n', 'd', delete_session)

        return true
      end,
    })
    :find()
end

-- Commands
vim.api.nvim_create_user_command('SessionSave', M.save, {})
vim.api.nvim_create_user_command('SessionLoad', M.load, {})
vim.api.nvim_create_user_command('SessionDeleteCurrent', M.delete_current, {})
vim.api.nvim_create_user_command('SessionPicker', function()
  telescope_sessions()
end, {})

-- Keymaps (adjust as needed)
vim.keymap.set('n', '<leader>ws', M.save, { desc = 'Session: Save' })
vim.keymap.set('n', '<leader>wl', M.load, { desc = 'Session: Load current' })
vim.keymap.set('n', '<leader>wp', telescope_sessions, { desc = 'Session: Picker (load/delete)' })
vim.keymap.set('n', '<leader>wd', M.delete_current, { desc = 'Session: Delete current' })

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return M
