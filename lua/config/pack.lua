-- vim.pack: Neovim 0.12 built-in plugin manager.
-- Eager: deps + UI plugins before first draw. Deferred: everything else via vim.schedule.

-- PackChanged hook must be registered before the first vim.pack.add() call.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('PackHooks', { clear = true }),
  callback = function(ev)
    if ev.kind ~= 'update' and ev.kind ~= 'install' then
      return
    end
    local spec = ev.spec or {}
    local is_treesitter = (spec.name or ''):match 'treesitter' or (spec.src or ''):match 'treesitter'
    if is_treesitter then
      pcall(function()
        vim.cmd.packadd 'nvim-treesitter'
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

-- Eager: ready before first draw
require 'config.deps'
require 'config.plugins.mini'
require 'config.plugins.whichkey'
require 'config.plugins.oil'
require 'config.plugins.fzf-lua'
-- nvim.undotree: built-in (0.12) visual undo-tree navigator, loaded eagerly so the <leader>ut keymap's require('undotree') works
vim.cmd.packadd 'nvim.undotree'
-- Deferred: run right after startup
local deferred = {
  'colorscheme',
  'neotree',
  'gitsigns',
  'treesitter',
  'flash',
  'markdown',
  'typst',
  'todo',
  'conform',
  'supermaven',
}
for _, name in ipairs(deferred) do
  vim.schedule(function()
    require('config.plugins.' .. name)
  end)
end
vim.schedule(function()
  require 'config.lsp.autocomplete'
end)
vim.schedule(function()
  require 'config.lsp.lspconfig'
end)

-- Plugin management keymaps
vim.keymap.set('n', '<leader>pu', function()
  vim.pack.update()
end, { desc = 'Update plugins' })
vim.keymap.set('n', '<leader>pU', function()
  vim.pack.update(nil, { force = true })
end, { desc = 'Update plugins (force)' })
vim.keymap.set('n', '<leader>pl', function()
  local lines = {}
  for _, p in ipairs(vim.pack.get()) do
    lines[#lines + 1] = string.format('%s %s', p.active and '✓' or ' ', p.spec and p.spec.name or '?')
  end
  table.sort(lines)
  vim.notify('Installed plugins:\n' .. table.concat(lines, '\n'))
end, { desc = 'List plugins' })
