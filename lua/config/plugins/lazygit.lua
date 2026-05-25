vim.pack.add({ 'https://github.com/kdheepak/lazygit.nvim' })

vim.api.nvim_create_user_command('LazyGit', function()
    require('lazygit').lazygit()
end, {})
vim.api.nvim_create_user_command('LazyGitCurrentFile', function()
    require('lazygit').lazygit { cwd = vim.fn.expand('%:p:h') }
end, {})
vim.api.nvim_create_user_command('LazyGitFilter', function(args)
    require('lazygit').lazygit { cwd = args.args }
end, { nargs = 1 })
vim.api.nvim_create_user_command('LazyGitFilterCurrentFile', function()
    require('lazygit').lazygit { cwd = vim.fn.expand('%:p') }
end, {})

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
