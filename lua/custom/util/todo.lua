local M = {}

-- [[ Configuration ]] ---------------------------------------------------------

local todo_config = {
    { keyword = 'TODO',  group = 'Todo_Todo_Bg' },
    { keyword = 'FIXME', group = 'Todo_Fixme_Bg' },
    { keyword = 'HACK',  group = 'Todo_Hack_Bg' },
    { keyword = 'NOTE',  group = 'Todo_Note_Bg' },
    { keyword = 'BUG',   group = 'Todo_Bug_Bg' },
    { keyword = 'PERF',  group = 'Todo_Perf_Bg' },
}

local text_group = 'Todo_Text'

-- [[ Highlight Groups ]] ------------------------------------------------------

function M.setup_highlight_groups()
    vim.api.nvim_set_hl(0, 'Todo_Todo_Bg', {
        fg = '#1E1E1E',
        bg = '#ADD8E6',
        bold = true,
        default = true,
    })

    vim.api.nvim_set_hl(0, 'Todo_Fixme_Bg', {
        fg = '#FFFFFF',
        bg = '#FF6347',
        bold = true,
        default = true,
    })

    vim.api.nvim_set_hl(0, 'Todo_Hack_Bg', {
        fg = '#1E1E1E',
        bg = '#FFA07A',
        bold = true,
        default = true,
    })

    vim.api.nvim_set_hl(0, 'Todo_Note_Bg', {
        fg = '#1E1E1E',
        bg = '#98FB98',
        bold = true,
        default = true,
    })

    vim.api.nvim_set_hl(0, 'Todo_Bug_Bg', {
        link = 'Todo_Fixme_Bg',
        default = true,
    })

    vim.api.nvim_set_hl(0, 'Todo_Perf_Bg', {
        fg = '#FFFFFF',
        bg = '#8A2BE2',
        bold = true,
        default = true,
    })

    vim.api.nvim_set_hl(0, text_group, {
        link = 'Comment',
        italic = true,
        default = true,
    })
end

-- [[ Keyword Highlighting ]] --------------------------------------------------

function M.setup_highlights()
    if vim.w.todo_match_ids then
        for _, id in ipairs(vim.w.todo_match_ids) do
            pcall(vim.fn.matchdelete, id)
        end
    end

    vim.w.todo_match_ids = {}

    for _, item in ipairs(todo_config) do
        local pattern = '\\<' .. item.keyword .. '\\>'
        local id = vim.fn.matchadd(item.group, pattern)
        table.insert(vim.w.todo_match_ids, id)
    end
end

-- [[ Autocmds ]] --------------------------------------------------------------

M.setup_highlight_groups()

vim.api.nvim_create_autocmd(
    { 'VimEnter', 'WinEnter', 'BufEnter', 'ColorScheme' },
    { callback = M.setup_highlights }
)

-- [[ Navigation ]] ------------------------------------------------------------

local function jump_todo(direction)
    local flags = (direction == 'next') and '' or 'b'
    local patterns = vim.tbl_map(function(t)
        return t.keyword
    end, todo_config)

    local pattern = '\\<\\(' .. table.concat(patterns, '\\|') .. '\\)\\>'
    vim.fn.search(pattern, flags)
end

vim.keymap.set('n', ']t', function()
    jump_todo('next')
end, { desc = 'Next TODO' })

vim.keymap.set('n', '[t', function()
    jump_todo('prev')
end, { desc = 'Previous TODO' })

-- [[ Ripgrep TODO Search (Quickfix) ]] ----------------------------------------

vim.keymap.set('n', '<leader>st', function()
    local pattern = [[\b(TODO|FIXME|BUG|NOTE|HACK|PERF)\b]]

    local cmd = {
        'rg',
        '--vimgrep', -- file:line:col:text (perfect for quickfix)
        '--no-ignore',
        pattern,
    }

    local result = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify('rg failed or no matches found', vim.log.levels.WARN)
        return
    end

    vim.fn.setqflist({}, ' ', {
        title = 'TODOs',
        lines = result,
    })

    vim.cmd('copen')
end, { desc = 'Search TODOs (ripgrep)' })

return M
