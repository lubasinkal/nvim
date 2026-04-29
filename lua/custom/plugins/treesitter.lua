return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    event = 'VeryLazy',
    config = function()
        require("nvim-treesitter").setup({})
    end
}
