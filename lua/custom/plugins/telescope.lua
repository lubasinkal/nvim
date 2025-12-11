return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = function()
                if vim.fn.executable 'zig' == 1 then
                    return 'zig build -Doptimize=ReleaseFast'
                else
                    return 'make'
                end
            end,
            cond = function()
                return vim.fn.executable 'make' == 1 or vim.fn.executable 'zig' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    keys = {
        { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
        { '<leader>sk', function() require('telescope.builtin').keymaps() end,   desc = '[S]earch [K]eymaps' },
        {
            '<leader>sf',
            function()
                local builtin = require('telescope.builtin')
                local git_ok = (vim.fn.isdirectory('.git') == 1)
                    or
                    (pcall(vim.fn.systemlist, 'git rev-parse --is-inside-work-tree') and vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1] == 'true')
                if git_ok then
                    pcall(builtin.git_files)
                else
                    pcall(builtin.find_files, { hidden = true })
                end
            end,
            desc = '[S]earch [F]iles (git-aware)',
        },
        { '<leader>ss',       function() require('telescope.builtin').builtin() end,     desc = '[S]earch [S]elect Telescope' },
        { '<leader>sw',       function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
        { '<leader>sg',       function() require('telescope.builtin').live_grep() end,   desc = '[S]earch by [G]rep' },
        { '<leader>sd',       function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
        { '<leader>sr',       function() require('telescope.builtin').resume() end,      desc = '[S]earch [R]esume' },
        { '<leader>s.',       function() require('telescope.builtin').oldfiles() end,    desc = '[S]earch Recent Files ("." for repeat)' },
        { '<leader><leader>', function() require('telescope.builtin').buffers() end,     desc = '[ ] Find existing buffers' },

        {
            '<leader>/',
            function()
                require('telescope.builtin').current_buffer_fuzzy_find(
                    require('telescope.themes').get_dropdown { winblend = 10, previewer = false }
                )
            end,
            desc = '[/] Fuzzily search in current buffer',
        },

        {
            '<leader>s/',
            function()
                require('telescope.builtin').live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end,
            desc = '[S]earch [/] in Open Files',
        },

        { '<leader>sn', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim files' },

        -- Buffer-related keymaps
        { '<leader>bb', function() require('telescope.builtin').buffers() end,                                    desc = '[B]uffer List' },
        { '<leader>br', function() require('telescope.builtin').oldfiles { only_cwd = true } end,                 desc = '[B]uffer [R]ecent (cwd)' },
        { '<leader>bm', function() require('telescope.builtin').marks() end,                                      desc = '[B]uffer [M]arks' },
        { '<leader>bd', '<cmd>bdelete<CR>',                                                                       desc = '[B]uffer [D]elete current' },
    },
    config = function()
        local actions = require('telescope.actions')

        require('telescope').setup {
            defaults = {
                vimgrep_arguments = {
                    'rg', '--color=never', '--no-heading', '--with-filename',
                    '--line-number', '--column', '--smart-case', '--hidden'
                },

                prompt_prefix = ' ',
                selection_caret = ' ',
                entry_prefix = '  ',
                initial_mode = 'insert',
                selection_strategy = 'reset',
                sorting_strategy = 'descending',
                layout_strategy = 'horizontal',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                        preview_width = 0.55,
                    },
                    vertical = { mirror = false },
                    width = 0.87,
                    height = 0.80,
                },

                path_display = { 'smart' },
                file_ignore_patterns = { 'node_modules', '%.git/', 'dist/', 'build/', '%.cache' },

                mappings = {
                    i = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-n>'] = actions.cycle_history_next,
                        ['<C-p>'] = actions.cycle_history_prev, -- keep history navigation on <C-p>
                        ['<C-c>'] = actions.close,
                        ['<C-x>'] = actions.select_horizontal,
                        ['<C-v>'] = actions.select_vertical,
                        ['<C-t>'] = actions.select_tab,
                        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
                        ['<C-d>'] = actions.delete_buffer,
                        -- Safe toggle preview: call at runtime, only if available
                        ['<C-l>'] = function(prompt_bufnr)
                            local ok, act = pcall(require, 'telescope.actions')
                            if ok and type(act.toggle_preview) == 'function' then
                                act.toggle_preview(prompt_bufnr)
                            else
                                vim.notify('Telescope: toggle_preview not available in this version', vim.log.levels
                                    .WARN)
                            end
                        end,
                    },
                    n = {
                        ['q'] = actions.close,
                        ['dd'] = actions.delete_buffer,
                        ['<CR>'] = actions.select_default,
                        -- Normal-mode toggle preview (safe)
                        ['<C-l>'] = function(prompt_bufnr)
                            local ok, act = pcall(require, 'telescope.actions')
                            if ok and type(act.toggle_preview) == 'function' then
                                act.toggle_preview(prompt_bufnr)
                            else
                                vim.notify('Telescope: toggle_preview not available in this version', vim.log.levels
                                    .WARN)
                            end
                        end,
                    },
                },
            },

            pickers = {
                find_files = { hidden = true, no_ignore = false, follow = true },
                buffers = {
                    sort_lastused = true,
                    theme = 'dropdown',
                    previewer = false,
                    mappings = {
                        i = { ['<C-d>'] = actions.delete_buffer },
                        n = { ['<C-d>'] = actions.delete_buffer },
                    },
                },
                current_buffer_fuzzy_find = { previewer = false, theme = 'dropdown' },
            },

            extensions = {
                ['ui-select'] = { require('telescope.themes').get_dropdown {} },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            },
        }

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        vim.api.nvim_create_autocmd('VimResized', {
            callback = function() pcall(require('telescope.actions.layout').resize) end,
        })
    end,
}
