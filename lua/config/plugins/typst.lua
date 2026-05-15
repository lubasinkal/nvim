return {
    'chomosuke/typst-preview.nvim',
    cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewUpdate" },
    keys = {
        {
            "<leader>tp",
            ft = "typst",
            "<cmd>TypstPreviewToggle<cr>",
            desc = "Toggle Typst Preview",
        },
    },
    opts = {
        port = 6767,

    }, -- lazy.nvim will implicitly calls `setup {}`
}
