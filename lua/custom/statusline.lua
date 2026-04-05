-- Native Neovim statusline with Diagnostics, Git, and simple LSP client names
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

-- 1. Highlights
local function apply_highlights()
  vim.api.nvim_set_hl(0, 'StMode', { fg = colors.black, bg = colors.violet })
  vim.api.nvim_set_hl(0, 'StModeInsert', { fg = colors.black, bg = colors.blue })
  vim.api.nvim_set_hl(0, 'StModeVisual', { fg = colors.black, bg = colors.cyan })
  vim.api.nvim_set_hl(0, 'StModeReplace', { fg = colors.black, bg = colors.red })
  vim.api.nvim_set_hl(0, 'StModeCommand', { fg = colors.black, bg = colors.mustard })
  vim.api.nvim_set_hl(0, 'StModeTerminal', { fg = colors.black, bg = colors.white })

  -- Position highlight (matches mode colors)
  vim.api.nvim_set_hl(0, 'StPos', { fg = colors.black, bg = colors.violet })
  vim.api.nvim_set_hl(0, 'StPosInsert', { fg = colors.black, bg = colors.blue })
  vim.api.nvim_set_hl(0, 'StPosVisual', { fg = colors.black, bg = colors.cyan })
  vim.api.nvim_set_hl(0, 'StPosReplace', { fg = colors.black, bg = colors.red })
  vim.api.nvim_set_hl(0, 'StPosCommand', { fg = colors.black, bg = colors.mustard })
  vim.api.nvim_set_hl(0, 'StPosTerminal', { fg = colors.black, bg = colors.white })

  -- Diagnostic Highlights
  vim.api.nvim_set_hl(0, 'StErr', { fg = colors.red })
  vim.api.nvim_set_hl(0, 'StWarn', { fg = colors.mustard })
  vim.api.nvim_set_hl(0, 'StHint', { fg = colors.cyan })
  vim.api.nvim_set_hl(0, 'StInfo', { fg = colors.blue })

  -- Git Highlight
  vim.api.nvim_set_hl(0, 'StGit', { fg = colors.violet, bold = true })
  vim.api.nvim_set_hl(0, 'StGitAdd', { fg = colors.cyan, bold = true })
  vim.api.nvim_set_hl(0, 'StGitDel', { fg = colors.red, bold = true })
end

apply_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { pattern = '*', callback = apply_highlights })

-- 2. Diagnostics
local function get_diagnostics()
  local res = {}
  local levels = {
    errors = vim.diagnostic.severity.ERROR,
    warnings = vim.diagnostic.severity.WARN,
    hints = vim.diagnostic.severity.HINT,
    info = vim.diagnostic.severity.INFO,
  }

  local err = #vim.diagnostic.get(0, { severity = levels.errors })
  local warn = #vim.diagnostic.get(0, { severity = levels.warnings })
  local hint = #vim.diagnostic.get(0, { severity = levels.hints })
  local info = #vim.diagnostic.get(0, { severity = levels.info })

  if err > 0 then
    table.insert(res, '%#StErr#󰅚 ' .. err)
  end
  if warn > 0 then
    table.insert(res, '%#StWarn#󰀪 ' .. warn)
  end
  if hint > 0 then
    table.insert(res, '%#StHint#󰌶 ' .. hint)
  end
  if info > 0 then
    table.insert(res, '%#StInfo#󰋽 ' .. info)
  end

  return table.concat(res, ' ')
end

-- 3. Git Branch and Changes
local function get_git_branch()
  local git_info = {}

  local branch = vim.b.gitsigns_head
  if branch and branch ~= '' then
    table.insert(git_info, '%#StGit#  ' .. branch .. ' ')

    local signs = vim.b.gitsigns_status_dict
    if signs then
      if signs.added and signs.added > 0 then
        table.insert(git_info, '%#StGitAdd#+' .. signs.added .. ' ')
      end
      if signs.removed and signs.removed > 0 then
        table.insert(git_info, '%#StGitDel#-' .. signs.removed .. ' ')
      elseif signs.changed and signs.changed > 0 then
        table.insert(git_info, '%#StGitDel#~' .. signs.changed .. ' ')
      end
    end
  end

  return table.concat(git_info, '')
end

-- 4. Simple LSP status – only shows attached client names
local function get_lsp_status()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return 'No LSP'
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return ' ' .. table.concat(names, ', ')
end

-- 5. Statusline
local modes = setmetatable({
  ['n'] = { 'Normal', 'N' },
  ['no'] = { 'N·Pending', 'N·P' },
  ['v'] = { 'Visual', 'V' },
  ['V'] = { 'V·Line', 'V·L' },
  ['\022'] = { 'V·Block', 'V·B' },
  ['s'] = { 'Select', 'S' },
  ['S'] = { 'S·Line', 'S·L' },
  ['\019'] = { 'S·Block', 'S·B' },
  ['i'] = { 'Insert', 'I' },
  ['ic'] = { 'Insert', 'I' },
  ['R'] = { 'Replace', 'R' },
  ['Rv'] = { 'V·Replace', 'V·R' },
  ['c'] = { 'Command', 'C' },
  ['cv'] = { 'Vim·Ex ', 'V·E' },
  ['ce'] = { 'Ex ', 'E' },
  ['r'] = { 'Prompt ', 'P' },
  ['rm'] = { 'More ', 'M' },
  ['r?'] = { 'Confirm ', 'C' },
  ['!'] = { 'Shell ', 'S' },
  ['t'] = { 'Terminal ', 'T' },
}, {
  __index = function()
    return { 'Unknown', 'U' }
  end,
})

local function get_mode_info(mode)
  local m = modes[mode] or modes[mode:sub(1, 2)]
  return m and m[1] or 'UNKNOWN', m and m[2] or 'U'
end

_G.statusline = function()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name, mode_short = get_mode_info(mode)

  local mode_hl = (mode == 'i' or mode == 'ic') and '%#StModeInsert#'
    or (mode == 'v' or mode == 'V' or mode == '\022') and '%#StModeVisual#'
    or (mode == 'R' or mode == 'Rv') and '%#StModeReplace#'
    or (mode == 'c' or mode == 'cv' or mode == 'ce') and '%#StModeCommand#'
    or (mode == 't' or mode == '!') and '%#StModeTerminal#'
    or (mode == 's' or mode == 'S' or mode == '\019') and '%#StModeVisual#'
    or '%#StMode#'

  local pos_hl = (mode == 'i' or mode == 'ic') and '%#StPosInsert#'
    or (mode == 'v' or mode == 'V' or mode == '\022' or mode == 's' or mode == 'S' or mode == '\019') and '%#StPosVisual#'
    or (mode == 'R' or mode == 'Rv') and '%#StPosReplace#'
    or (mode == 'c' or mode == 'cv' or mode == 'ce') and '%#StPosCommand#'
    or (mode == 't' or mode == '!') and '%#StPosTerminal#'
    or '%#StPos#'

  return table.concat {
    mode_hl,
    ' ',
    mode_name,
    ' ',
    get_git_branch(),
    get_diagnostics(),
    ' ',
    '%#StMiddle#',
    '%=',
    vim.fn.expand '%:t',
    '%=',
    '%#StText#',
    ' ',
    get_lsp_status(),
    '  ',
    vim.bo.filetype,
    '  %p%% ',
    pos_hl,
    ' Ln %l: Col %c ',
  }
end

vim.o.statusline = '%!v:lua.statusline()'

-- ============== Smart Redraws for Better Performance ==============
local statusline_augroup = vim.api.nvim_create_augroup('StatuslineUpdate', { clear = true })

vim.api.nvim_create_autocmd({
  'ModeChanged',
  'DiagnosticChanged',
  'LspAttach',
  'LspDetach',
  'BufEnter',
  'BufWritePost',
}, {
  group = statusline_augroup,
  pattern = '*',
  callback = vim.schedule_wrap(function()
    vim.cmd 'redrawstatus'
  end),
})

-- Export
return {
  apply_highlights = apply_highlights,
}
