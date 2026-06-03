return {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'FzfLua',
    keys = {
        -- Search (prefixed with leader s)
        { '<leader>sh', '<cmd>FzfLua help_tags<CR>',            desc = 'Help' },
        { '<leader>sk', '<cmd>FzfLua keymaps<CR>',              desc = 'Keymaps' },
        { '<leader>sw', '<cmd>FzfLua grep_cword<CR>',           desc = 'Current Word' },
        { '<leader>sw', '<cmd>FzfLua grep_visual<CR>',          desc = 'Current Selection', mode = 'v' },
        { '<leader>sg', '<cmd>FzfLua live_grep<CR>',            desc = 'Grep' },
        { '<leader>sG', '<cmd>FzfLua grep_project<CR>',         desc = 'Grep (Project)' },
        { '<leader>sb', '<cmd>FzfLua grep_curbuf<CR>',          desc = 'Grep Buffer' },
        { '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', desc = 'Diagnostics' },
        { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<CR>',desc = 'Diagnostics (Workspace)' },
        { '<leader>sr', '<cmd>FzfLua resume<CR>',               desc = 'Resume' },
        { '<leader>s.', '<cmd>FzfLua oldfiles<CR>',             desc = 'Recent Files' },
        { '<leader>ss', '<cmd>FzfLua builtin<CR>',             desc = 'FzfLua Builtin' },
        { '<leader>sf', '<cmd>FzfLua files<CR>',                desc = 'Files' },
        {
            '<leader>sn',
            function()
                require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
            end,
            desc = 'Neovim Files',
        },
        { '<leader>sH', '<cmd>FzfLua highlights<CR>',           desc = 'Highlights' },
        { '<leader>sc', '<cmd>FzfLua colorschemes<CR>',         desc = 'Colorscheme' },
        { '<leader>sR', '<cmd>FzfLua registers<CR>',            desc = 'Registers' },
        { '<leader>s?', '<cmd>FzfLua spell_suggest<CR>',        desc = 'Spell Suggest' },
        -- Git
        { '<leader>gf', '<cmd>FzfLua git_files<CR>',    desc = 'Git Files' },
        { '<leader>gc', '<cmd>FzfLua git_commits<CR>',  desc = 'Git Commits' },
        { '<leader>gC', '<cmd>FzfLua git_bcommits<CR>', desc = 'Buffer Commits' },
        { '<leader>gb', '<cmd>FzfLua git_branches<CR>', desc = 'Git Branches' },
        { '<leader>gs', '<cmd>FzfLua git_status<CR>',   desc = 'Git Status' },
        -- Buffers (prefixed with leader b)
        { '<leader>bb', '<cmd>FzfLua buffers<CR>',       desc = 'Buffers' },
        { '<leader>br', '<cmd>FzfLua oldfiles<CR>',     desc = 'Recent' },
        { '<leader>bm', '<cmd>FzfLua marks<CR>',        desc = 'Marks' },
        { '<leader>bl', '<cmd>FzfLua blines<CR>',       desc = 'Buffer Lines' },
    },
    config = function()
        local fzf = require 'fzf-lua'

        fzf.setup {
            winopts = {
                height = 0.85,
                width = 0.80,
                preview = {
                    layout = 'horizontal',
                    horizontal = 'right:50%',
                    scrollbar = false,
                },
            },
            keymap = {
                fzf = {
                    ['ctrl-j'] = 'down',
                    ['ctrl-k'] = 'up',
                    ['ctrl-q'] = 'select-all+accept',
                },
                builtin = {
                    ['ctrl-c'] = 'close',
                    ['ctrl-x'] = 'jump-accept',
                    ['ctrl-v'] = 'jump',
                    ['ctrl-t'] = 'jump-tab',
                },
            },
            buffers = {
                sort_lastused = true,
                previewer = false,
                winopts = {
                    height = 0.4,
                    width = 0.6,
                    row = 0.4,
                },
            },
            oldfiles = {
                include_current_session = true,
            },
            lsp = {
                async_or_timeout = 5000,
                symbols = {
                    symbol_style = 1,
                },
            },
        }

        fzf.register_ui_select()
    end,
}
