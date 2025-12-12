local M = {}

-- Configuration
local config = {
  win_opts = {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    focusable = false,
    height = 1,
    width = 30,
    zindex = 50,
  },
  timeout = 2000, -- Clear after 2 seconds of inactivity
}

local state = {
  enabled = false,
  buf = -1,
  win = -1,
  timer = nil,
  keys = {},
  ns_id = vim.api.nvim_create_namespace('native_screenkey'),
}

local function get_win_config()
  local height = config.win_opts.height
  local width = config.win_opts.width
  -- Position at bottom right
  local row = vim.o.lines - vim.o.cmdheight - height - 2
  local col = vim.o.columns - width - 1

  return vim.tbl_extend('force', config.win_opts, {
    row = row,
    col = col,
  })
end

local function update_window()
  if not state.enabled then return end

  -- Create buffer if needed
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].buftype = 'nofile'
    vim.bo[state.buf].filetype = 'screenkey'
  end

  -- Create window if needed
  if not vim.api.nvim_win_is_valid(state.win) then
    state.win = vim.api.nvim_open_win(state.buf, false, get_win_config())
    vim.wo[state.win].winblend = 20 -- Transparent background
  else
    -- Update position in case of resize
    vim.api.nvim_win_set_config(state.win, get_win_config())
  end

  -- Update content
  local text = table.concat(state.keys, ' ')
  -- Truncate from left if too long
  if #text > config.win_opts.width - 2 then
    text = '...' .. string.sub(text, #text - (config.win_opts.width - 5))
  end
  
  -- Center text
  local padding = math.floor((config.win_opts.width - #text) / 2)
  local line = string.rep(' ', padding) .. text
  
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { line })
end

local function clear_keys()
  state.keys = {}
  if vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {})
  end
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = -1
  end
end

local function on_key(char)
  if not state.enabled then return end
  
  -- Ignore empty chars
  if not char or char == '' then return end

  -- Translate special keys
  local key = vim.fn.keytrans(char)
  
  -- Skip some boring keys if needed, but keytrans handles most well
  if key == '<Nop>' then return end

  table.insert(state.keys, key)
  
  -- Keep history reasonable
  if #state.keys > 10 then
    table.remove(state.keys, 1)
  end

  update_window()

  -- Reset timer to clear
  if state.timer then
    state.timer:stop()
    state.timer:close()
  end
  
  state.timer = vim.loop.new_timer()
  state.timer:start(config.timeout, 0, vim.schedule_wrap(clear_keys))
end

function M.toggle()
  state.enabled = not state.enabled
  if state.enabled then
    vim.notify('ScreenKey Enabled', vim.log.levels.INFO)
    -- Start listening
    if not state.on_key_ns then
      state.on_key_ns = vim.on_key(on_key, state.ns_id)
    end
  else
    vim.notify('ScreenKey Disabled', vim.log.levels.INFO)
    clear_keys()
    -- Stop listening (vim.on_key returns existing callback if called again, 
    -- but actually to remove it we pass nil? No, vim.on_key doc says: 
    -- "The function is removed by calling it with nil."
    -- Wait, vim.on_key(func, ns) registers it.
    -- To remove, we should probably just rely on state.enabled flag for simplicity 
    -- because removing global on_key listeners can be tricky if not careful.
    -- But let's try to be clean.
    -- Actually, simple flag check is safest and fastest.
  end
end

-- Resize handler
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    if state.enabled and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_set_config(state.win, get_win_config())
    end
  end
})

-- Command
vim.api.nvim_create_user_command('ScreenKeyToggle', M.toggle, {})

-- Keymap matching previous plugin
vim.keymap.set('n', '<leader>tsk', M.toggle, { desc = '[T]oggle [S]creen[K]ey' })

return M
