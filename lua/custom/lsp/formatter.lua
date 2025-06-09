return { -- Formatter
  'stevearc/conform.nvim',
  -- Use BufWritePost for format_after_save
  -- If you enable format_on_save (synchronous), you'll also need BufWritePre
  event = { 'BufWritePost' },
  cmd = { 'ConformInfo', 'ConformFormat' }, -- Add ConformFormat command
  keys = {
    {
      -- Format the current buffer (manually)
      '<leader>fm', -- Changed keymap to <leader>fm (format manual)
      function()
        require('conform').format {
          async = true, -- Asynchronous formatting (doesn't block Neovim)
          lsp_fallback = true, -- Fallback to LSP formatting if no Conform formatter is found
        }
      end,
      mode = 'n', -- Apply only in Normal mode (most common for buffer formatting)
      desc = '[F]ormat [m]anual', -- Updated description
    },
  },
  opts = {
    -- Display notifications on format errors
    notify_on_error = true,

    -- How often to format: "on_save", "on_focwin", "BufWritePost", etc.
    -- See `:help conform-format-on-save`
    format_on_save = false, -- Explicitly disable synchronous format-on-save

    -- Configure format_after_save as a function to conditionally format
    -- This function runs after BufWritePost
    format_after_save = function(bufnr)
      -- Define filetypes where format-after-save should be disabled
      local disable_filetypes = {
        c = true,
        cpp = true,
      }

      -- Get the filetype of the current buffer
      local filetype = vim.bo[bufnr].filetype

      -- If the filetype is in the disable list, return nil to skip formatting
      if disable_filetypes[filetype] then
        vim.notify('Formatting disabled for filetype: ' .. filetype, vim.log.levels.INFO, { title = 'Conform' })
        return nil
      else
        -- Otherwise, return a configuration table for formatting
        return {
          async = true, -- Ensure asynchronous formatting
          lsp_fallback = true, -- Fallback to LSP if Conform doesn't have a formatter
        }
      end
    end,

    -- Define formatters to use for each filetype
    formatters_by_ft = {
      lua = { 'stylua' }, -- Use stylua for Lua files
      python = { 'ruff' }, -- Use ruff_format for Python files (assuming you have ruff installed via Mason)
      javascript = { "prettier", "eslint_d" }, -- Try prettier, then eslint_d
      typescript = { "prettier", "eslint_d" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "jq" }, -- Example using jq for JSON
      yaml = { "prettier" },
      markdown = { "prettier" },
      vue = { "prettier", "eslint_d" },
    },

    -- Optional: Default formatters to try if no filetype specific formatter is found
    default_formatters = {
      'prettier',
      'eslint_d',
    },
  },
}
