return {
  'stevearc/conform.nvim',
  event = 'BufWritePost',
  cmd = { 'ConformInfo', 'ConformFormat' },
  keys = {
    {
      '<leader>fm',
      function()
        require('conform').format {
          async = true,
          lsp_fallback = true,
        }
      end,
      mode = 'n',
      desc = '[F]ormat [M]anually',
    },
    {
      '<leader>ft',
      function()
        local conf = require 'conform'
        conf.format_on_save = not conf.format_on_save
        vim.notify('Format on Save: ' .. (conf.format_on_save and 'Enabled' or 'Disabled'), vim.log.levels.INFO, {
          title = 'Conform',
        })
      end,
      mode = 'n',
      desc = '[F]ormat [T]oggle on Save',
    },
  },
  opts = function()
    -- Ensure required formatters are installed via Mason
    local ensure = {
      'stylua',
      'ruff',
      'biome',
      'black',
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure, -- correct variable here
      run_on_start = false, -- disable auto-run, handled below
      auto_update = true,
    }

    return {
      notify_on_error = true,
      format_on_save = false,
      format_after_save = function(bufnr)
        local disabled_ft = { c = true, cpp = true }
        local ft = vim.bo[bufnr].filetype
        if disabled_ft[ft] then
          vim.notify('Formatting disabled for ' .. ft, vim.log.levels.INFO, { title = 'Conform' })
          return nil
        end
        return {
          async = true,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        html = { 'biome' },
        css = { 'biome' },
        json = { 'biome' },
      },
      default_formatters = { 'biome' },
    }
  end,
}
