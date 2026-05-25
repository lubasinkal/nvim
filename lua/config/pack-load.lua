-- vim.pack: Load and configure all plugins
--
-- All plugins live in pack/myskill/start/ and are auto-loaded via packpath.
-- Every require is wrapped in pcall so first-bootstrap doesn't error.

local function try_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify('[pack] skipping ' .. mod .. ' (not yet installed: ' .. tostring(err):gsub('^.-: ', '') .. ')',
      vim.log.levels.WARN)
  end
  return ok
end

local M = {}

function M.setup()
  -- ── UI / visual ──
  try_require('config.plugins.whichkey')
  try_require('config.plugins.colorscheme')
  try_require('config.plugins.markdown')
  try_require('config.plugins.todo')

  -- ── Treesitter ──
  try_require('config.plugins.treesitter')

  -- ── Editing / navigation ──
  try_require('config.plugins.flash')
  try_require('config.plugins.mini')
  try_require('config.plugins.gitsigns')
  try_require('config.plugins.neotree')
  try_require('config.plugins.oil')
  try_require('config.plugins.lazygit')

  -- ── Telescope ──
  try_require('config.plugins.telescope')

  -- ── LSP / completion ──
  try_require('config.lsp.autocomplete')
  try_require('config.lsp.lspconfig')

  -- ── Misc ──
  try_require('config.plugins.typst')
end

return M
