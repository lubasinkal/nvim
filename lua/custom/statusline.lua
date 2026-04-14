vim.o.termguicolors = true

local colors = {
    violet = '#d183e8',
    grey = '#3a3a3a',
    blue = '#80a0ff',
    cyan = '#79dac8',
    red = '#ff5189',
    mustard = '#f2c811',
    white = '#c6c6c6',
    black = '#0d0d0f',
}

-- 1. Highlights (kept your nice mode colors)
local function apply_highlights()
    -- Mode
    vim.api.nvim_set_hl(0, 'StMode', { fg = colors.black, bg = colors.violet })
    vim.api.nvim_set_hl(0, 'StModeInsert', { fg = colors.black, bg = colors.blue })
    vim.api.nvim_set_hl(0, 'StModeVisual', { fg = colors.black, bg = colors.cyan })
    vim.api.nvim_set_hl(0, 'StModeReplace', { fg = colors.black, bg = colors.red })
    vim.api.nvim_set_hl(0, 'StModeCommand', { fg = colors.black, bg = colors.mustard })
    vim.api.nvim_set_hl(0, 'StModeTerminal', { fg = colors.black, bg = colors.white })

    -- Position (matches mode)
    vim.api.nvim_set_hl(0, 'StPos', { fg = colors.black, bg = colors.violet })
    vim.api.nvim_set_hl(0, 'StPosInsert', { fg = colors.black, bg = colors.blue })
    vim.api.nvim_set_hl(0, 'StPosVisual', { fg = colors.black, bg = colors.cyan })
    vim.api.nvim_set_hl(0, 'StPosReplace', { fg = colors.black, bg = colors.red })
    vim.api.nvim_set_hl(0, 'StPosCommand', { fg = colors.black, bg = colors.mustard })
    vim.api.nvim_set_hl(0, 'StPosTerminal', { fg = colors.black, bg = colors.white })

    -- Diagnostics
    vim.api.nvim_set_hl(0, 'StErr', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'StWarn', { fg = colors.mustard })
    vim.api.nvim_set_hl(0, 'StHint', { fg = colors.cyan })
    vim.api.nvim_set_hl(0, 'StInfo', { fg = colors.blue })

    -- Git
    vim.api.nvim_set_hl(0, 'StGit', { fg = colors.violet })
    vim.api.nvim_set_hl(0, 'StGitAdd', { fg = colors.cyan })
    vim.api.nvim_set_hl(0, 'StGitDel', { fg = colors.red })

    -- Simple middle/text (you can change these)
    vim.api.nvim_set_hl(0, 'StMiddle', { fg = colors.white })
    vim.api.nvim_set_hl(0, 'StText', { fg = colors.white })
end
apply_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_highlights })

-- 2. Diagnostics — now just one native call (0.12+)
-- Customize icons + highlights exactly like you had before
vim.diagnostic.config({
    status = {
        format = function(counts)
            local parts = {}
            local icons = {
                [vim.diagnostic.severity.ERROR] = { '󰅚 ', 'StErr' },
                [vim.diagnostic.severity.WARN]  = { '󰀪 ', 'StWarn' },
                [vim.diagnostic.severity.HINT]  = { '󰌶 ', 'StHint' },
                [vim.diagnostic.severity.INFO]  = { '󰋽 ', 'StInfo' },
            }
            for severity, count in pairs(counts) do
                local icon, hl = unpack(icons[severity] or { '? ', 'StInfo' })
                table.insert(parts, string.format('%%#%s#%s%d', hl, icon, count))
            end
            return table.concat(parts, ' ')
        end,
    },
})

local function get_diagnostics()
    return vim.diagnostic.status(0) or ''
end

-- 3. Git (unchanged — still the fastest way with gitsigns)
local function get_git_branch()
    local branch = vim.b.gitsigns_head
    if not branch or branch == '' then return '' end

    local info = { '%#StGit#  ' .. branch .. ' ' }
    local signs = vim.b.gitsigns_status_dict
    if signs then
        if signs.added and signs.added > 0 then
            table.insert(info, '%#StGitAdd#+' .. signs.added .. ' ')
        end
        if signs.removed and signs.removed > 0 then
            table.insert(info, '%#StGitDel#-' .. signs.removed .. ' ')
        elseif signs.changed and signs.changed > 0 then
            table.insert(info, '%#StGitDel#~' .. signs.changed .. ' ')
        end
    end
    return table.concat(info)
end

-- 4. Simple LSP client names (exactly what you wanted)
local function get_lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return 'No LSP' end
    local names = {}
    for _, c in ipairs(clients) do table.insert(names, c.name) end
    return ' ' .. table.concat(names, ', ')
end

-- 5. Mode helper (kept compact)
local modes = {
    n = { 'Normal', 'N' },
    no = { 'N·Pending', 'N·P' },
    v = { 'Visual', 'V' },
    V = { 'V·Line', 'V·L' },
    ['\022'] = { 'V·Block', 'V·B' },
    s = { 'Select', 'S' },
    S = { 'S·Line', 'S·L' },
    ['\019'] = { 'S·Block', 'S·B' },
    i = { 'Insert', 'I' },
    ic = { 'Insert', 'I' },
    R = { 'Replace', 'R' },
    Rv = { 'V·Replace', 'V·R' },
    c = { 'Command', 'C' },
    cv = { 'Vim·Ex', 'V·E' },
    ce = { 'Ex', 'E' },
    r = { 'Prompt', 'P' },
    rm = { 'More', 'M' },
    ['r?'] = { 'Confirm', 'C' },
    ['!'] = { 'Shell', 'S' },
    t = { 'Terminal', 'T' },
}
local function get_mode()
    local mode = vim.api.nvim_get_mode().mode
    local m = modes[mode] or modes[mode:sub(1, 2)] or { 'IDK', 'U' }
    return m[1], m[2]
end

-- 6. The actual render (super clean)
_G.statusline = function()
    local mode_name = get_mode() -- we only need the full name for display

    -- Mode highlight
    local mode = vim.api.nvim_get_mode().mode
    local mode_hl = (mode == 'i' or mode == 'ic') and '%#StModeInsert#'
        or (mode == 'v' or mode == 'V' or mode == '\022' or mode == 's' or mode == 'S' or mode == '\019') and
        '%#StModeVisual#'
        or (mode == 'R' or mode == 'Rv') and '%#StModeReplace#'
        or (mode == 'c' or mode == 'cv' or mode == 'ce') and '%#StModeCommand#'
        or (mode == 't' or mode == '!') and '%#StModeTerminal#'
        or '%#StMode#'

    -- Position highlight (same logic)
    local pos_hl = (mode == 'i' or mode == 'ic') and '%#StPosInsert#'
        or (mode == 'v' or mode == 'V' or mode == '\022' or mode == 's' or mode == 'S' or mode == '\019') and
        '%#StPosVisual#'
        or (mode == 'R' or mode == 'Rv') and '%#StPosReplace#'
        or (mode == 'c' or mode == 'cv' or mode == 'ce') and '%#StPosCommand#'
        or (mode == 't' or mode == '!') and '%#StPosTerminal#'
        or '%#StPos#'

    return table.concat({
        mode_hl, ' ', mode_name, ' ',
        get_git_branch(),
        ' %#StMiddle#', vim.fn.expand('%:t'), '%=',
        '%#StText# ',
        get_lsp_status(), ' ',
        get_diagnostics(), ' ',
        vim.bo.filetype, ' %p%% ',
        pos_hl, ' %l:%c ',
    })
end

-- Set it
vim.o.statusline = '%!v:lua.statusline()'

-- Smart redraws (keeps it snappy)
vim.api.nvim_create_autocmd({
    'ModeChanged', 'DiagnosticChanged', 'LspAttach', 'LspDetach',
    'BufEnter', 'BufWritePost', 'LspProgress',
}, {
    callback = vim.schedule_wrap(function() vim.cmd('redrawstatus') end),
})
