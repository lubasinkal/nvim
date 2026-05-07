local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'

local function ensure_session_dir()
    if vim.fn.isdirectory(session_dir) == 0 then
        vim.fn.mkdir(session_dir, 'p')
    end
end

local function get_session_filename()
    local cwd = vim.fn.getcwd()
    local name = vim.fs.basename(cwd)

    if vim.uv.fs_stat('.git') then
        local branch = vim.fn.systemlist('git branch --show-current')[1]
        local valid = branch and #branch < 50 and branch:match('^[%w%-%_]+$')
        if vim.v.shell_error == 0 and valid and branch ~= 'main' and branch ~= 'master' then
            name = name .. '%%' .. branch
        end
    end

    return session_dir .. name .. '.vim'
end

function M.branch()
    if vim.uv.fs_stat('.git') then
        local ret = vim.fn.systemlist('git branch --show-current')[1]
        return vim.v.shell_error == 0 and ret or nil
    end
    return nil
end

function M.save()
    ensure_session_dir()
    local path = get_session_filename()
    vim.cmd('mksession! ' .. vim.fn.fnameescape(path))
    vim.notify('Session saved → ' .. vim.fn.fnamemodify(path, ':~'), vim.log.levels.INFO)
end

function M.load()
    local path = get_session_filename()
    if vim.fn.filereadable(path) == 1 then
        vim.cmd('source ' .. vim.fn.fnameescape(path))
        vim.notify('Session loaded', vim.log.levels.INFO)
    else
        local fallback = session_dir .. vim.fn.getcwd():gsub('[\\/:]+', '%%') .. '.vim'
        if vim.fn.filereadable(fallback) == 1 then
            vim.cmd('source ' .. vim.fn.fnameescape(fallback))
            vim.notify('Session loaded (no branch)', vim.log.levels.INFO)
        else
            vim.notify('No session found for this project', vim.log.levels.WARN)
        end
    end
end

function M.delete()
    local path = get_session_filename()
    if vim.fn.filereadable(path) == 1 then
        vim.fn.delete(path)
        vim.notify('Session deleted', vim.log.levels.INFO)
    else
        vim.notify('No session to delete', vim.log.levels.WARN)
    end
end

function M.list()
    local files = vim.fn.glob(session_dir .. '*.vim', false, true)
    if #files == 0 then
        vim.notify('No saved sessions', vim.log.levels.WARN)
        return
    end
    local items = {}
    for _, f in ipairs(files) do
        table.insert(items, { path = f, name = vim.fn.fnamemodify(f, ':t:r') })
    end
    vim.ui.select(items, {
        prompt = 'Sessions (Enter=load, d=delete):',
        format_item = function(item) return item.name end,
    }, function(choice)
        if not choice then return end
        vim.ui.select({ 'load', 'delete' }, {
            prompt = 'Action:',
        }, function(action)
            if action == 'load' then
                vim.cmd('source ' .. vim.fn.fnameescape(choice.path))
                vim.notify('Loaded: ' .. choice.name, vim.log.levels.INFO)
            elseif action == 'delete' then
                vim.fn.delete(choice.path)
                vim.notify('Deleted: ' .. choice.name, vim.log.levels.INFO)
            end
        end)
    end)
end

vim.api.nvim_create_user_command('SessionSave', M.save, {})
vim.api.nvim_create_user_command('SessionLoad', M.load, {})
vim.api.nvim_create_user_command('SessionDelete', M.delete, {})
vim.api.nvim_create_user_command('SessionList', M.list, {})

vim.keymap.set('n', '<leader>ws', M.save, { desc = '[S]ave session' })
vim.keymap.set('n', '<leader>wl', M.load, { desc = '[L]oad current' })
vim.keymap.set('n', '<leader>wd', M.delete, { desc = '[D]elete current' })
vim.keymap.set('n', '<leader>wL', M.list, { desc = '[L]ist sessions' })

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return M
