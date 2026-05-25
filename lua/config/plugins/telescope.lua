vim.pack.add({ 'https://github.com/nvim-telescope/telescope.nvim' })
vim.pack.add({ 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' })
vim.pack.add({ 'https://github.com/nvim-telescope/telescope-ui-select.nvim' })
vim.pack.add({ 'https://github.com/nvim-telescope/telescope-frecency.nvim' })
vim.pack.add({ 'https://github.com/olacin/telescope-cc.nvim' })

local actions = require('telescope.actions')

require('telescope').setup({
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.55 },
        },
        path_display = { 'smart' },
        mappings = {
            i = {
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-c>'] = actions.close,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,
                ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
                ['<C-d>'] = actions.delete_buffer,
            },
            n = { ['q'] = actions.close, ['dd'] = actions.delete_buffer },
        },
    },
    pickers = {
        buffers = { sort_lastused = true, theme = 'dropdown', previewer = false },
        current_buffer_fuzzy_find = { previewer = false, theme = 'dropdown' },
    },
    extensions = {
        ['ui-select'] = require('telescope.themes').get_dropdown {},
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        frecency = {
            auto_validate = false,
            matcher = "fuzzy",
            path_display = { "filename_first" },
        },
        conventional_commits = { include_body_and_footer = true },
    },
})

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'frecency')
pcall(require('telescope').load_extension, 'conventional_commits')

-- Keymaps
vim.keymap.set('n', '<leader>sh', '<cmd>Telescope help_tags<CR>', { desc = '[H]elp' })
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = '[K]eymaps' })
vim.keymap.set('n', '<leader>sw', '<cmd>Telescope grep_string<CR>', { desc = 'Current [W]ord' })
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<CR>', { desc = 'By [G]rep' })
vim.keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics<CR>', { desc = '[D]iagnostics' })
vim.keymap.set('n', '<leader>sr', '<cmd>Telescope resume<CR>', { desc = '[R]esume' })
vim.keymap.set('n', '<leader>s.', '<cmd>Telescope oldfiles<CR>', { desc = 'Recent [.] Files' })
vim.keymap.set('n', '<leader>ss', '<cmd>Telescope builtin<CR>', { desc = '[S]elect Telescope' })
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope find_files<CR>', { desc = '[F]iles' })
vim.keymap.set('n', '<leader>sn', function()
    require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[N]eovim files' })
vim.keymap.set('n', '<leader>gf', '<cmd>Telescope git_files<CR>', { desc = '[F]iles' })
vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { desc = '[C]ommits' })
vim.keymap.set('n', '<leader>gC', '<cmd>Telescope git_bcommits<CR>', { desc = '[B]uffer [C]ommits' })
vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', { desc = '[B]ranches' })
vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<CR>', { desc = '[S]tatus' })
vim.keymap.set('n', '<leader>cc', '<cmd>Telescope conventional_commits<CR>', { desc = '[C]onventional [C]ommit' })
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope buffers<CR>', { desc = '[B]uffers' })
vim.keymap.set('n', '<leader>br', '<cmd>Telescope oldfiles<CR>', { desc = '[R]ecent' })
vim.keymap.set('n', '<leader>bm', '<cmd>Telescope marks<CR>', { desc = '[M]arks' })
