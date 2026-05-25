-- vim.pack: Neovim built-in package manager using the native packpath
--
-- Manages plugins in ~/.local/share/nvim/site/pack/myskill/{start,opt}/
--   start/ → auto-loaded at startup
--   opt/   → loaded on demand via :packadd
--
-- Usage:
--   :lua require('config.pack').install()   -- clone missing plugins
--   :lua require('config.pack').update()    -- git pull all plugins
--   :lua require('config.pack').clean()     -- remove unlisted dirs
--   :lua require('config.pack').list()      -- show installed status
--   :lua require('config.pack').status()    -- show git status

local M = {}

local pack_base = vim.fn.stdpath('data') .. '/site/pack/myskill'
local start_dir = pack_base .. '/start'
local opt_dir   = pack_base .. '/opt'

-- ── Plugin spec ──────────────────────────────────────────────────────
-- Each entry: { name, repo, branch?, build?, lazy? }
--   name   – directory name (also used for :packadd and require)
--   repo   – GitHub "user/repo" or full URL
--   branch – optional branch to checkout
--   build  – optional build command run after clone/pull
--   lazy   – if true → opt/ (manual packadd), else start/ (auto-load)

M.spec = {
  -- Core dependencies
  { name = 'plenary.nvim',         repo = 'nvim-lua/plenary.nvim' },
  { name = 'nui.nvim',             repo = 'MunifTanjim/nui.nvim' },
  { name = 'vim-fugitive',         repo = 'tpope/vim-fugitive' },

  -- UI / visual
  { name = 'which-key.nvim',       repo = 'folke/which-key.nvim' },
  { name = 'cyberdream.nvim',      repo = 'scottmckendry/cyberdream.nvim' },
  { name = 'render-markdown.nvim', repo = 'MeanderingProgrammer/render-markdown.nvim' },
  { name = 'todo-comments.nvim',   repo = 'folke/todo-comments.nvim', deps = { 'plenary.nvim' } },

  -- Treesitter
  { name = 'nvim-treesitter',      repo = 'nvim-treesitter/nvim-treesitter' },

  -- Code / LSP
  { name = 'nvim-lspconfig',       repo = 'neovim/nvim-lspconfig' },
  { name = 'mason.nvim',           repo = 'williamboman/mason.nvim' },
  { name = 'mason-lspconfig.nvim', repo = 'williamboman/mason-lspconfig.nvim' },
  { name = 'fidget.nvim',          repo = 'j-hui/fidget.nvim' },
  { name = 'blink.cmp',            repo = 'saghen/blink.cmp',
    branch = 'v1' },            -- stable v1.x (v2 is still in development)
  { name = 'friendly-snippets',    repo = 'rafamadriz/friendly-snippets' },

  -- Git
  { name = 'gitsigns.nvim',        repo = 'lewis6991/gitsigns.nvim' },
  { name = 'lazygit.nvim',         repo = 'kdheepak/lazygit.nvim' },

  -- Navigation / editing
  { name = 'flash.nvim',           repo = 'folke/flash.nvim' },
  { name = 'neo-tree.nvim',        repo = 'nvim-neo-tree/neo-tree.nvim', branch = 'v3.x' },
  { name = 'oil.nvim',             repo = 'stevearc/oil.nvim' },
  { name = 'mini.nvim',            repo = 'echasnovski/mini.nvim' },
  { name = 'mini.icons',           repo = 'nvim-mini/mini.icons' },

  -- Telescope + extensions
  { name = 'telescope.nvim',                repo = 'nvim-telescope/telescope.nvim' },
  { name = 'telescope-fzf-native.nvim',     repo = 'nvim-telescope/telescope-fzf-native.nvim',
    build = function(plugin_dir)
      if vim.fn.executable 'zig' == 1 then
        return 'zig build -Doptimize=ReleaseFast'
      elseif vim.fn.executable 'make' == 1 then
        return 'make'
      end
      return nil -- Lua fallback
    end
  },
  { name = 'telescope-ui-select.nvim',      repo = 'nvim-telescope/telescope-ui-select.nvim' },
  { name = 'telescope-frecency.nvim',       repo = 'nvim-telescope/telescope-frecency.nvim' },
  { name = 'telescope-cc.nvim',             repo = 'olacin/telescope-cc.nvim' },
  { name = 'tailwindcss-colorizer-cmp.nvim',repo = 'roobert/tailwindcss-colorizer-cmp.nvim' },

  -- Language-specific
  { name = 'typst-preview.nvim',            repo = 'chomosuke/typst-preview.nvim' },
}

-- ── Helpers ──────────────────────────────────────────────────────────

local function plugin_dir(plugin)
  local base = plugin.lazy and opt_dir or start_dir
  return base .. '/' .. plugin.name
end

local function ensure_dirs()
  for _, d in ipairs { start_dir, opt_dir } do
    if vim.fn.mkdir(d, 'p') == 0 then
      vim.notify('[pack] failed to create ' .. d, vim.log.levels.ERROR)
    end
  end
end

local function repo_url(repo)
  if repo:match('^https?://') or repo:match('^git@') then
    return repo
  end
  return 'https://github.com/' .. repo .. '.git'
end

-- Run git command in plugin directory using -C (cross-platform, no shell escaping issues)
local function run_git(dir, args)
  local cmd = { 'git', '-C', dir }
  for _, a in ipairs(args) do
    cmd[#cmd + 1] = a
  end
  local result = vim.fn.system(cmd)
  local ok = vim.v.shell_error == 0
  return ok, vim.trim(result or '')
end

-- Run arbitrary build command in plugin directory
-- On Windows, use cmd /c with double quotes; on Unix, use sh -c
local function run_build(dir, build_cmd)
  local cmd
  if vim.fn.has 'win32' == 1 then
    -- Windows: double quotes inside cmd /c
    cmd = { 'cmd', '/c', 'cd /d ' .. vim.fn.fnameescape(dir) .. ' && ' .. build_cmd }
  else
    cmd = { 'sh', '-c', 'cd ' .. vim.fn.shellescape(dir) .. ' && ' .. build_cmd }
  end
  local result = vim.fn.system(cmd)
  local ok = vim.v.shell_error == 0
  return ok, vim.trim(result or '')
end

-- ── Core operations ──────────────────────────────────────────────────

--- Clone a single plugin if not already present.
function M.install_one(plugin)
  local dir = plugin_dir(plugin)
  if vim.fn.isdirectory(dir) == 1 then
    return true, 'already installed'
  end

  local url = repo_url(plugin.repo)
  local cmd = { 'git', 'clone', '--filter=blob:none' }
  if plugin.branch then
    cmd[#cmd + 1] = '--branch'
    cmd[#cmd + 1] = plugin.branch
  end
  cmd[#cmd + 1] = url
  cmd[#cmd + 1] = dir

  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return false, out
  end

  -- Run build step if present
  if plugin.build then
    local build_cmd = type(plugin.build) == 'function' and plugin.build(dir) or plugin.build
    if build_cmd then
      local bok, bout = run_build(dir, build_cmd)
      if not bok then
        return false, 'clone OK, build failed:\n' .. bout
      end
    end
  end

  return true, 'installed'
end

--- Clone all missing plugins.
function M.install()
  ensure_dirs()
  local results = {}
  for _, plugin in ipairs(M.spec) do
    local ok, msg = M.install_one(plugin)
    results[#results + 1] = string.format('  %s %s → %s', ok and '✓' or '✗', plugin.name, msg)
    vim.notify(string.format('[pack] %s %s', plugin.name, ok and 'installed' or 'failed'), ok and vim.log.levels.INFO or vim.log.levels.ERROR)
  end
  return table.concat(results, '\n')
end

--- Update (git pull) all installed plugins.
function M.update()
  ensure_dirs()
  local results = {}
  for _, plugin in ipairs(M.spec) do
    local dir = plugin_dir(plugin)
    if vim.fn.isdirectory(dir) == 1 then
      local ok, out = run_git(dir, { 'pull', '--ff-only', '--rebase=false' })
      if ok then
        -- With list args, stderr may not be captured; handle both empty and msg cases
        local was_updated = out ~= '' and not (out or ''):match 'Already up to date'
        results[#results + 1] = string.format('  ✓ %s  %s', plugin.name, was_updated and 'updated' or 'up-to-date')
        if was_updated then
          vim.notify('[pack] updated ' .. plugin.name, vim.log.levels.INFO)
        end
      else
        results[#results + 1] = string.format('  ✗ %s  %s', plugin.name, out:match '%S.*')
        vim.notify('[pack] update failed: ' .. plugin.name .. '\n' .. out, vim.log.levels.ERROR)
      end
      -- Re-run build after update
      if plugin.build then
        local build_cmd = type(plugin.build) == 'function' and plugin.build(dir) or plugin.build
        if build_cmd then
          local bok, bout = run_build(dir, build_cmd)
          if not bok then
            results[#results + 1] = string.format('  ⚠ %s build failed: %s', plugin.name, bout)
          end
        end
      end
    else
      local ok, msg = M.install_one(plugin)
      results[#results + 1] = string.format('  %s %s %s', ok and '✓' or '✗', plugin.name, msg)
    end
  end
  vim.notify('[pack] update complete', vim.log.levels.INFO)
  return table.concat(results, '\n')
end

--- Remove directories not in the spec (clean orphaned plugins).
function M.clean()
  ensure_dirs()
  local spec_names = {}
  for _, p in ipairs(M.spec) do
    spec_names[p.name] = true
  end

  local removed = {}
  for _, base in ipairs { start_dir, opt_dir } do
    local handle = vim.uv or vim.loop
    local fs = handle.fs_scandir(base)
    if fs then
      while true do
        local name = handle.fs_scandir_next(fs)
        if not name then break end
        local full = base .. '/' .. name
        if vim.fn.isdirectory(full) == 1 and not spec_names[name] then
          vim.fn.delete(full, 'rf')
          removed[#removed + 1] = name
        end
      end
    end
  end

  if #removed > 0 then
    vim.notify('[pack] removed: ' .. table.concat(removed, ', '), vim.log.levels.INFO)
  else
    vim.notify('[pack] no orphaned plugins', vim.log.levels.INFO)
  end
  return removed
end

--- List installed plugins and their status.
function M.list()
  ensure_dirs()
  local lines = {}
  for _, plugin in ipairs(M.spec) do
    local dir = plugin_dir(plugin)
    local exists = vim.fn.isdirectory(dir) == 1
    local location = plugin.lazy and 'opt' or 'start'
    local status = exists and 'installed' or 'missing'
    lines[#lines + 1] = string.format('  [%s] %-30s %s (%s)', location, plugin.name, status, plugin.repo)
  end
  return table.concat(lines, '\n')
end

--- Show git status of each plugin (behind/ahead/dirty).
function M.status()
  local lines = {}
  for _, plugin in ipairs(M.spec) do
    local dir = plugin_dir(plugin)
    if vim.fn.isdirectory(dir) == 1 then
      local ok, out = run_git(dir, { 'status', '--short', '--branch' })
      if ok then
        local first_line = out:match '^[^\n]+'
        lines[#lines + 1] = string.format('  %s: %s', plugin.name, first_line or 'clean')
      else
        lines[#lines + 1] = string.format('  %s: error reading status', plugin.name)
      end
    else
      lines[#lines + 1] = string.format('  %s: not installed', plugin.name)
    end
  end
  return table.concat(lines, '\n')
end

-- Expose directories for use in init.lua
M.start_dir = start_dir
M.opt_dir   = opt_dir

return M

-- Keymaps
-- <leader>pu – update plugins
-- <leader>pl – list plugins
-- <leader>pc – clean orphaned plugins
