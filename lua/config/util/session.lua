local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'

local function ensure_session_dir()
    if vim.fn.isdirectory(session_dir) == 0 then
        vim.fn.mkdir(session_dir, 'p')
    end
end

local function get_session_filename()
    local cwd = vim.uv.cwd()
    local name = vim.fs.basename(cwd)
    return vim.fs.joinpath(session_dir, name .. '.vim')
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
        vim.notify('No session found for this project', vim.log.levels.WARN)
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

local function get_session_name(path)
    return vim.fn.fnamemodify(path, ':t:r')
end

function M.list()
    local files = vim.fn.glob(session_dir .. '*.vim', false, true)
    if #files == 0 then
        vim.notify('No saved sessions', vim.log.levels.WARN)
        return
    end
    require('telescope.pickers').new({
        prompt_title = 'Sessions',
        finder = require('telescope.finders').new_table {
            results = files,
            entry_maker = function(entry)
                return { value = entry, display = get_session_name(entry), ordinal = get_session_name(entry) }
            end,
        },
        sorter = require('telescope.config').values.generic_sorter,
        attach_mappings = function(prompt_bufnr, map)
            require('telescope.actions.set').edit(prompt_bufnr, 'goto_selection')
            map('i', '<c-d>', function()
                local selection = require('telescope.actions.state').get_selected_entry()
                if selection then
                    vim.fn.delete(selection.value)
                    require('telescope.actions').close(prompt_bufnr)
                    vim.notify('Deleted: ' .. get_session_name(selection.value), vim.log.levels.INFO)
                    vim.cmd('SessionList')
                end
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command('SessionSave', M.save, {})
vim.api.nvim_create_user_command('SessionLoad', M.load, {})
vim.api.nvim_create_user_command('SessionDelete', M.delete, {})
vim.api.nvim_create_user_command('SessionList', M.list, {})

vim.keymap.set('n', '<leader>ws', M.save, { desc = '[S]ave session' })
vim.keymap.set('n', '<leader>wl', M.load, { desc = '[L]oad current' })
vim.keymap.set('n', '<leader>wd', M.delete, { desc = '[D]elete current' })
vim.keymap.set('n', '<leader>wL', M.list, { desc = '[L]ist (Telescope)' })

vim.api.nvim_create_user_command('SessionList', M.list, {})

vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return M
