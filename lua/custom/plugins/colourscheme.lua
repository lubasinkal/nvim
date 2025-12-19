return {
    {
        "folke/tokyonight.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("tokyonight").setup({
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                }
            })
            vim.cmd [[colorscheme tokyonight-night]]
        end,
    },
}
