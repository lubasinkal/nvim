--[[
kickstart.nvim health check

This is NOT required for your config to work.
It's only meant to help new users quickly see obvious setup problems.
--]]

local M = {}

local version_check = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end
  if vim.version.ge(vim.version(), '0.11') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local function check_executables()
  local required = {
    { cmd = 'git', purpose = 'plugin manager, lazy.nvim updates, many git-based operations' },
    { cmd = 'rg', purpose = 'very fast grep → used by many telescope pickers & live_grep' },
    { cmd = 'fd', purpose = 'very fast find → telescope find_files, many plugins' },
  }

  local recommended = {
    { cmd = 'make', purpose = 'building some LSP servers / treesitter parsers' },
    { cmd = 'unzip', purpose = 'unpacking some downloaded LSP servers / plugins' },
    { cmd = 'curl', purpose = 'downloading LSP servers, Mason fallback' },
    { cmd = 'python3', purpose = 'many LSP servers, debugpy, python treesitter' },
    { cmd = 'node', purpose = 'typescript-language-server, many JS/TS tools' },
  }

  vim.health.info 'Checking commonly used external commands:'

  for _, entry in ipairs(required) do
    if vim.fn.executable(entry.cmd) == 1 then
      vim.health.ok(string.format('  %-8s  (%s)', entry.cmd, entry.purpose))
    else
      vim.health.error(string.format('  %-8s  missing  (%s)', entry.cmd, entry.purpose))
    end
  end

  vim.health.info ''

  for _, entry in ipairs(recommended) do
    if vim.fn.executable(entry.cmd) == 1 then
      vim.health.ok(string.format('  %-8s  (%s)', entry.cmd, entry.purpose))
    else
      vim.health.warn(string.format('  %-8s  not found  (%s)', entry.cmd, entry.purpose))
    end
  end
end

function M.check()
  vim.health.start 'kickstart.nvim'

  vim.health.info [[
  Not every warning here is a hard requirement.
  Fix only the things that affect plugins/languages you actually use.
  ]]

  local uv = vim.uv or vim.loop
  vim.health.info('System: ' .. vim.inspect(uv.os_uname()))

  version_check()
  vim.health.info ''

  check_executables()
  vim.health.info ''
end

return M
