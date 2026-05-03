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

    -- Try to detect git repo + branch
    local git_dir = vim.uv.fs_stat(vim.fs.joinpath(cwd, '.git'))
    if git_dir and git_dir.type == 'directory' then
        local git_root = vim.fn.trim(vim.fn.system 'git rev-parse --show-toplevel 2>/dev/null')
        if vim.v.shell_error == 0 and git_root ~= '' then
            name = git_root:gsub('[/\\:]+', '_')
            local branch = vim.fn.trim(vim.fn.system 'git branch --show-current 2>/dev/null')
            if vim.v.shell_error == 0 and branch ~= '' and branch ~= 'main' and branch ~= 'master' then
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
        vim.notify('No session found for this project', vim.log.levels.WARN)
    end
end

function M.delete_current()
    local path = get_session_filename()
    if vim.fn.filereadable(path) == 1 then
        vim.fn.delete(path)
        vim.notify('Deleted session: ' .. vim.fn.fnamemodify(path, ':t'), vim.log.levels.INFO)
    else
        vim.notify('No session to delete', vim.log.levels.WARN)
    end
end

-- Simple interactive multi-delete (optional – can be removed if you prefer manual :SessionDeletePattern)
function M.delete_picker()
    local files = vim.fn.glob(session_dir .. '*.vim', false, true)
    if #files == 0 then
        vim.notify('No saved sessions', vim.log.levels.WARN)
        return
    end

    local items = {}
    for _, f in ipairs(files) do
        local name = vim.fn.fnamemodify(f, ':t:r')
        table.insert(items, { path = f, name = name })
    end

    vim.ui.select(items, {
        prompt = 'Select session to delete (or Esc to cancel):',
        format_item = function(item)
            return item.name
        end,
    }, function(choice)
        if not choice then
            return
        end
        vim.fn.delete(choice.path)
        vim.notify('Deleted: ' .. choice.name, vim.log.levels.INFO)
    end)
end

-- Commands
vim.api.nvim_create_user_command('SessionSave', M.save, {})
vim.api.nvim_create_user_command('SessionLoad', M.load, {})
vim.api.nvim_create_user_command('SessionDelete', M.delete_current, {})

-- Optional: more dangerous bulk delete
vim.api.nvim_create_user_command('SessionDeletePattern', function(opts)
    local pattern = opts.args
    if pattern == '' then
        vim.notify('Usage: :SessionDeletePattern <pattern>', vim.log.levels.ERROR)
        return
    end
    local deleted = 0
    for _, file in ipairs(vim.fn.glob(session_dir .. '*.vim', false, true)) do
        if vim.fn.fnamemodify(file, ':t'):find(pattern, 1, true) then
            vim.fn.delete(file)
            deleted = deleted + 1
        end
    end
    vim.notify('Deleted ' .. deleted .. ' session file(s)', vim.log.levels.INFO)
end, { nargs = 1, complete = 'file' })

-- Recommended keymaps
vim.keymap.set('n', '<leader>ws', M.save, { desc = '[S]ave' })
vim.keymap.set('n', '<leader>wl', M.load, { desc = '[L]oad' })
vim.keymap.set('n', '<leader>wd', M.delete_current, { desc = '[D]elete' })
-- vim.keymap.set("n", "<leader>wD", M.delete_picker, { desc = "Session: Pick & delete" })

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return M
