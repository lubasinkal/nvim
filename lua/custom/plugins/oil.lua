return {
    'stevearc/oil.nvim',
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    cmd = { 'Oil', 'Oil --float' },
    keys = {
        {
            '-',
            '<CMD>Oil<CR>',
            desc = 'Open Oil (parent directory)',
        },
        { '<leader>e', '<CMD>Oil --float --preview<CR>', desc = 'File [E]xplorer' }
    },
    -- Plugin options
    opts = {
        lsp_file_methods = {
            -- Enable or disable LSP file operations
            enabled = false,
        },
    },

}
