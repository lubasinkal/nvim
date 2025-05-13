return { -- Formatter
  'stevearc/conform.nvim',
  -- Use BufWritePost for format_after_save
  -- If you enable format_on_save (synchronous), you'll also need BufWritePre
  event = { 'BufWritePost', 'BufWritePre' },
  cmd = { 'ConformInfo', 'ConformFormat' }, -- Add ConformFormat command
  keys = {
    {
      -- Format the current buffer (manually)
      '<leader>fm', -- Changed keymap to <leader>fm (format manual)
      function()
        require('conform').format {
          async = true, -- Asynchronous formatting (doesn't block Neovim)
          lsp_fallback = true, -- Fallback to LSP formatting if no Conform formatter is found
          -- Use a range to format a visual selection
          -- range = vim.fn.mode() == 'v' and vim.api.nvim_buf_get_mark(0, '<') and vim.api.nvim_buf_get_mark(0, '>')
        }
      end,
      mode = 'n', -- Apply only in Normal mode (most common for buffer formatting)
      -- If you want to format a visual selection, you'd add 'x' mode and the range option
      -- mode = { 'n', 'x' },
      desc = '[F]ormat [m]anual', -- Updated description
    },
    -- Optional: Keymap for formatting a visual selection specifically
    -- {
    --   '<leader>fv',
    --   function()
    --     require('conform').format {
    --       async = true,
    --       lsp_fallback = true,
    --       range = vim.api.nvim_buf_get_mark(0, '<') and vim.api.nvim_buf_get_mark(0, '>'),
    --     }
    --   end,
    --   mode = 'x',
    --   desc = '[F]ormat [v]isual selection',
    -- },
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
        -- Add other filetypes to disable if needed
        -- markdown = true,
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
          -- timeout_ms = 5000, -- Optional: Increase timeout if formatters are slow
        }
      end
    end,

    -- Optional: Keep this if you want sync formatting too (not recommended with slow formatters)
    -- This runs *before* saving, triggered by BufWritePre
    -- format_on_save = function(bufnr)
    --   local disable_filetypes = { c = true, cpp = true }
    --   if disable_filetypes[vim.bo[bufnr].filetype] then
    --     return nil
    --   else
    --     return {
    --       timeout_ms = 2500, -- longer timeout if needed
    --       lsp_fallback = true,
    --     }
    --   end
    -- end,

    -- Define formatters to use for each filetype
    formatters_by_ft = {
      lua = { 'stylua' }, -- Use stylua for Lua files
      python = { 'ruff' }, -- Use ruff_format for Python files (assuming you have ruff installed via Mason)
      -- Add more formatters as needed
      javascript = { "prettier", "eslint_d" }, -- Try prettier, then eslint_d
      typescript = { "prettier", "eslint_d" },
      -- go = { "gofumpt", "goimports" }, -- Try gofumpt, then goimports
      html = { "prettier" },
      css = { "prettier" },
      json = { "jq" }, -- Example using jq for JSON
      yaml = { "prettier" },
      markdown = { "prettier" },
      -- sh = { "shfmt" },
      vue = { "prettier", "eslint_d" },
      -- Add '*-lsp' to use the LSP server's formatting capabilities
      -- lua = { "stylua", "lua_ls-lsp" },
    },

    -- Optional: Default formatters to try if no filetype specific formatter is found
    default_formatters = {
      'prettier',
      'eslint_d',
    },

    -- Optional: Configure options for specific formatters
    -- formatters = {
    --   prettier = {
    --     args = { "--print-width", "100" },
    --   },
    --   ruff_format = {
    --     -- Ruff formatter options go here if needed
    --   },
    -- },
  },
}
