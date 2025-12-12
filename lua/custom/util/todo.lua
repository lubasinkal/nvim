local M = {}

-- Todo Highlights and Navigation

local todo_patterns = {
  { 'TODO',  'WarningMsg' },
  { 'FIXME', 'ErrorMsg' },
  { 'HACK',  'WarningMsg' },
  { 'NOTE',  'Directory' },
  { 'BUG',   'ErrorMsg' },
}

function M.setup_highlights()
  -- Clear existing matches for this window
  if vim.w.todo_match_ids then
    for _, id in ipairs(vim.w.todo_match_ids) do
      pcall(vim.fn.matchdelete, id)
    end
  end
  vim.w.todo_match_ids = {}

  for _, item in ipairs(todo_patterns) do
    local pattern, group = unpack(item)
    -- Add match for the keyword followed by colon or space
    -- We use [[:punct:]] to catch things like TODO: or TODO(user):
    local id = vim.fn.matchadd(group, '\\<' .. pattern .. '\\>.*')
    table.insert(vim.w.todo_match_ids, id)
  end
end

-- Re-apply highlights on buffer enter/win enter because matchadd is window-local
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufEnter' }, {
  callback = M.setup_highlights,
})

-- Navigation
local function jump_todo(direction)
  local flags = (direction == 'next') and '' or 'b'
  -- Search for any of the patterns
  local pattern = '\\(' .. table.concat(vim.tbl_map(function(t) return t[1] end, todo_patterns), '\\|') .. '\\)'
  vim.fn.search(pattern, flags)
end

vim.keymap.set('n', ']t', function() jump_todo('next') end, { desc = 'Next todo comment' })
vim.keymap.set('n', '[t', function() jump_todo('prev') end, { desc = 'Previous todo comment' })

return M
