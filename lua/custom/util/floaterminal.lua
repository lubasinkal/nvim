local M = {}

-- Exit terminal mode quickly
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  floating = {
    buf = -1,
    win = -1,
    autocmd_id = nil,
  },
}

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
    state.floating.buf = buf
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
  state.floating.win = win

  -- Clean up any existing autocmd
  if state.floating.autocmd_id then
    pcall(vim.api.nvim_del_autocmd, state.floating.autocmd_id)
    state.floating.autocmd_id = nil
  end

  -- Start terminal if buffer isn't already one
  if vim.bo[buf].buftype ~= 'terminal' then
    -- Save the current window to return to it later
    local current_win = vim.api.nvim_get_current_win()

    -- Switch to the floating window
    vim.api.nvim_set_current_win(win)

    -- Open terminal - using :terminal command which works like :terminal in normal Neovim
    vim.cmd 'terminal'

    -- Return to original window
    vim.api.nvim_set_current_win(current_win)

    vim.bo[buf].buflisted = false
  else
    -- Buffer is already a terminal, just ensure we're in the right window
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(win)
    vim.cmd 'startinsert'
    vim.api.nvim_set_current_win(current_win)
  end

  -- Set some window options for better experience
  vim.api.nvim_win_set_option(win, 'winblend', 0)
  vim.api.nvim_win_set_option(win, 'wrap', false)

  -- Auto-close terminal when job ends
  state.floating.autocmd_id = vim.api.nvim_create_autocmd('TermClose', {
    buffer = buf,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
        state.floating.win = -1
      end
      state.floating.autocmd_id = nil
    end,
    once = true,
  })

  return { buf = buf, win = win }
end

local function toggle_terminal()
  -- If window is valid and visible, hide it
  if vim.api.nvim_win_is_valid(state.floating.win) then
    local win_config = vim.api.nvim_win_get_config(state.floating.win)
    if win_config.relative ~= '' then -- It's a floating window
      vim.api.nvim_win_hide(state.floating.win)
      return
    end
  end

  -- Otherwise, create/show the floating terminal
  state.floating = create_floating_window()
end

-- Optional: Function to close terminal completely
local function close_terminal()
  -- Clean up autocmd first
  if state.floating.autocmd_id then
    pcall(vim.api.nvim_del_autocmd, state.floating.autocmd_id)
    state.floating.autocmd_id = nil
  end

  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
  end
  if vim.api.nvim_buf_is_valid(state.floating.buf) then
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
  end
  state.floating = { buf = -1, win = -1, autocmd_id = nil }
end

-- Command + keymaps
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.api.nvim_create_user_command('FloaterminalClose', close_terminal, {})

vim.keymap.set('n', '<Leader>tt', toggle_terminal, { desc = 'Toggle Floating Terminal' })
vim.keymap.set('n', '<Leader>tc', close_terminal, { desc = 'Close Floating Terminal' })

-- Optional: Resize on VimResized event
local resize_autocmd_id = nil
local function setup_resize_autocmd()
  if resize_autocmd_id then
    vim.api.nvim_del_autocmd(resize_autocmd_id)
  end

  resize_autocmd_id = vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
      if vim.api.nvim_win_is_valid(state.floating.win) then
        -- Recalculate and update window size
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)

        vim.api.nvim_win_set_config(state.floating.win, {
          relative = 'editor',
          width = width,
          height = height,
          col = col,
          row = row,
        })
      end
    end,
  })
end

setup_resize_autocmd()

return M
