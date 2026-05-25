vim.pack.add({ 'https://github.com/scottmckendry/cyberdream.nvim' })

require('cyberdream').setup({
    transparent = true,
    italic_comments = true,
    terminal_colors = true,
})
vim.cmd('colorscheme cyberdream')
