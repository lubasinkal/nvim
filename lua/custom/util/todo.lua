local M = {}

-- [[ Configuration ]] ---------------------------------------------------------
-- Define your TODO patterns and the dedicated highlight group name they should link to.
local todo_config = {
    { keyword = 'TODO',  group = 'Todo_Todo_Bg' },
    { keyword = 'FIXME', group = 'Todo_Fixme_Bg' },
    { keyword = 'HACK',  group = 'Todo_Hack_Bg' },
    { keyword = 'NOTE',  group = 'Todo_Note_Bg' },
    { keyword = 'BUG',   group = 'Todo_Bug_Bg' },
    { keyword = 'PERF',  group = 'Todo_Perf_Bg' },
}

-- The highlight group for the *text* following the keyword. (Can remain linked)
local text_group = 'Todo_Text'


-- [[ Highlight Group Setup (Setting explicit Backgrounds) ]] ------------------

function M.setup_highlight_groups()
    -- ---
    -- 1. Define groups with specific Background and Foreground colors
    -- You can use vim.api.nvim_get_hl_by_name to pull existing colors,
    -- but for simplicity, we use explicit hex codes here.
    -- ---

    -- **TODO (Light Blue Background, Dark Foreground)**
    vim.api.nvim_set_hl(0, 'Todo_Todo_Bg', {
        fg = '#1E1E1E', -- Dark text
        bg = '#ADD8E6', -- Light blue background
        bold = true,
        default = true
    })

    -- **FIXME/BUG (Red Background, Light Foreground)**
    vim.api.nvim_set_hl(0, 'Todo_Fixme_Bg', {
        fg = '#FFFFFF', -- White text
        bg = '#FF6347', -- Tomato red background
        bold = true,
        default = true
    })

    -- **HACK (Orange/Yellow Background, Dark Foreground)**
    vim.api.nvim_set_hl(0, 'Todo_Hack_Bg', {
        fg = '#1E1E1E', -- Dark text
        bg = '#FFA07A', -- Light salmon background
        bold = true,
        default = true
    })

    -- **NOTE (Green/Directory color, Dark Foreground)**
    vim.api.nvim_set_hl(0, 'Todo_Note_Bg', {
        fg = '#1E1E1E', -- Dark text
        bg = '#98FB98', -- Pale green background
        bold = true,
        default = true
    })

    -- **BUG (Using FIXME group for consistency)**
    vim.api.nvim_set_hl(0, 'Todo_Bug_Bg', { link = 'Todo_Fixme_Bg', default = true })

    -- **PERF (Purple/Keyword color, Light Foreground)**
    vim.api.nvim_set_hl(0, 'Todo_Perf_Bg', {
        fg = '#FFFFFF', -- White text
        bg = '#8A2BE2', -- Blue violet background
        bold = true,
        default = true
    })

    -- 2. Define the style for the *rest of the comment text* (optional, using default comment style)
    vim.api.nvim_set_hl(0, text_group, { link = 'Comment', default = true, italic = true })
end

-- [[ Highlighting (Using matchadd to apply background only to the keyword) ]] --

function M.setup_highlights()
    -- Clear existing matches for this window
    if vim.w.todo_match_ids then
        for _, id in ipairs(vim.w.todo_match_ids) do
            pcall(vim.fn.matchdelete, id)
        end
    end
    vim.w.todo_match_ids = {}

    for _, item in ipairs(todo_config) do
        -- Regex explanation:
        -- 1. \<pattern\>: Match the keyword at a word boundary.
        local pattern = '\\<' .. item.keyword .. '\\>'

        -- The key change: We apply the background group ONLY to the keyword pattern.
        local id = vim.fn.matchadd(item.group, pattern)
        table.insert(vim.w.todo_match_ids, id)

        -- OPTIONAL: Highlight the rest of the line with the 'Todo_Text' group
        -- This applies the 'Comment' link/italic style to the rest of the comment text.
        -- local text_id = vim.fn.matchadd(text_group, '\\<' .. item.keyword .. '\\>\\%([ :()-]*\\)\\zs.*')
        -- table.insert(vim.w.todo_match_ids, text_id)
    end
end

-- [[ Autocmds and Keymaps ]] --------------------------------------------------

-- Ensure highlight groups are set up (important to run this once before Autocmds)
M.setup_highlight_groups()

-- Re-apply highlights on buffer enter/win enter and when colorscheme changes
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufEnter', 'ColorScheme' }, {
    callback = M.setup_highlights,
})

-- Navigation (No changes needed here, still searches for the keyword)
local function jump_todo(direction)
    local flags = (direction == 'next') and '' or 'b'
    local patterns = vim.tbl_map(function(t) return t.keyword end, todo_config)
    local pattern = '\\<\\(' .. table.concat(patterns, '\\|') .. '\\)'
    vim.fn.search(pattern, flags)
end

vim.keymap.set('n', ']t', function() jump_todo('next') end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function() jump_todo('prev') end, { desc = 'Previous todo comment' })

return M
