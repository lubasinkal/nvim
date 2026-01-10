return {
    'stevearc/conform.nvim',
    event = 'BufWritePost',
    cmd = { 'ConformInfo', 'ConformFormat' },
    opts = {
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = 'fallback',
        },
        format_after_save = {
            lsp_format = "fallback",
        },
        notify_on_error = true,
        -- Conform will notify you when no formatters are available for the buffer
        notify_no_formatters = true,
        formatters_by_ft = {
            javascript = { 'biome' },
            typescript = { 'biome' },
            vue = { 'biome' },
            html = { 'biome' },
            css = { 'biome' },
            json = { 'biome' },
        },
    },
}
