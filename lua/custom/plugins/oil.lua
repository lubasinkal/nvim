return {
    'stevearc/oil.nvim',
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    cmd = { 'Oil', 'Oil --float' },
    keys = {
        {
            '-',
            '<CMD>Oil<CR>',
            desc = 'Open Oil (parent directory)',
        },
    },
    -- Plugin options
    opts = {
        lsp_file_methods = {
            -- Enable or disable LSP file operations
            enabled = false,
        },
    },
}
