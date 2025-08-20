local M = {}

-- Exit terminal mode quickly
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

-- Detect an available shell
local function get_shell()
  if vim.fn.has 'win32' == 1 then
    if vim.fn.executable 'pwsh.exe' == 1 then
      return { 'pwsh.exe', '-NoLogo' }
    elseif vim.fn.executable 'powershell.exe' == 1 then
      return { 'powershell.exe', '-NoLogo' }
    end
  else
    if vim.fn.executable 'bash' == 1 then
      return { 'bash' }
    elseif vim.fn.executable 'zsh' == 1 then
      return { 'zsh' }
    elseif vim.fn.executable 'sh' == 1 then
      return { 'sh' }
    end
  end
  return { vim.o.shell } -- fallback
end

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Reuse buffer if valid, else create a new scratch buffer
  local buf = state.floating.buf
  if not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buflisted = false
    vim.bo[buf].swapfile = false
  end

  -- Floating window config
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Start terminal if buffer isn’t already one
  if vim.bo[buf].buftype ~= 'terminal' then
    vim.fn.termopen(get_shell())
    vim.bo[buf].buflisted = false
  end

  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window()
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Command + keymap
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set('n', '<Leader>tt', toggle_terminal, { desc = 'Toggle Floating Terminal' })

return M
