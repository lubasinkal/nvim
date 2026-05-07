return {
    "scottmckendry/cyberdream.nvim",
    name = 'cyberdream',
    event = 'VeryLazy',
    config = function()
        require("cyberdream").setup({
            transparent = true,
            italic_comments = true,
            terminal_colors = true,
        })
        vim.cmd("colorscheme cyberdream")
    end,
}
