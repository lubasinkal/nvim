return {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    keys = { { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
        { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
    },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('bufferline').setup {
            options = {
                mode = 'buffers',
                themable = true,
                numbers = 'none',
                modified_icon = '●', -- Minimal dot for modified buffers
                left_trunc_marker = ' ',
                right_trunc_marker = ' ',
                max_name_length = 20,
                max_prefix_length = 15,
                tab_size = 18,
                diagnostics = 'nvim_lsp',

                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = ' '
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == ' error' and '  ' or (e == ' warning' and '  ' or '  ')
                        s = s .. n .. sym
                    end
                    return s
                end,
                color_icons = true,
                show_buffer_icons = true, -- Show filetype icons
                separator_style = { '│', '│' },
                enforce_regular_tabs = true,
                always_show_bufferline = false,
                auto_toggle_bufferline = true,
                indicator = {
                    style = 'none', -- Options: 'icon', 'underline', 'none'
                },
                sort_by = 'insert_at_end',
            },
        }
    end,
}
