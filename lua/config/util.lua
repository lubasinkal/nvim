-- Single-file util (was util/floaterminal.lua)
local M = {}

local state = { buf = -1, win = -1 }

function M.toggle()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    return
  end
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local buf = state.buf
  if not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    state.buf = buf
  end
  state.win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })
  if vim.bo[buf].buftype ~= 'terminal' then
    vim.cmd 'terminal'
    vim.bo[buf].buflisted = false
  else
    vim.cmd 'startinsert'
  end
end

vim.api.nvim_create_autocmd('TermClose', {
  callback = function(ev)
    if ev.buf == state.buf then
      if vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
      end
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
      state.buf, state.win = -1, -1
    end
  end,
})

return M
