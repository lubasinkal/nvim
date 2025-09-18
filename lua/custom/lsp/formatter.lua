return {
  'stevearc/conform.nvim',
  event = 'BufWritePost',
  cmd = { 'ConformInfo', 'ConformFormat' },
  opts = function()
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
