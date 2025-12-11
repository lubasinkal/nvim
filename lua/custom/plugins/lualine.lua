return {
    'nvim-lualine/lualine.nvim',
    event = 'BufReadPost',
    dependencies = 'nvim-web-devicons',
    config = function()
        local icons = {
            lsp = ' ', -- LSP
        }
        local colors = {
            blue = '#80a0ff',
            cyan = '#79dac8',
            black = '#0d0d0f',
            white = '#c6c6c6',
            red = '#ff5189',
            violet = '#d183e8',
            grey = '#08080f',
            mustard = '#f2c811',
        }

        local bubbles_theme = {
            normal = {
                a = { fg = colors.black, bg = colors.violet },
                b = { fg = colors.white, bg = colors.grey },
                c = { fg = colors.white },
            },
            insert = {
                a = { fg = colors.black, bg = colors.blue },
            },
            visual = {
                a = { fg = colors.black, bg = colors.cyan },
            },
            replace = {
                a = { fg = colors.black, bg = colors.red },
            },
            command = {
                a = { fg = colors.black, bg = colors.mustard },
            },
            inactive = {
                -- Improved contrast for inactive windows
                a = { fg = colors.white, bg = '#1d1d21' },
                b = { fg = colors.white, bg = '#1d1d21' },
                c = { fg = '#949494' }, -- Lighter grey for main inactive content
            },
        }

        local function lsp_clients()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if next(clients) == nil then
                return 'No LSP'
            end
            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return icons.lsp .. table.concat(names, ', ')
        end

        require('lualine').setup {
            options = {
                theme = bubbles_theme,
                icons_enabled = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                -- ... (other options unchanged)
                always_divide_middle = false,
            },
            sections = {
                lualine_a = { 'mode' },
                -- Group contextual info: Branch, Diagnostics, LSP
                lualine_b = {
                    { 'branch' },
                    { lsp_clients, maxwidth = 30 } -- LSP client list with maxwidth
                },
                -- Central focus: Filename with path and file status
                lualine_c = {
                    { 'filename', path = 0, file_status = true },
                    'diagnostics'
                },
                -- Right-center info: Encoding, Filetype
                lualine_x = { 'encoding', 'filetype' },
                -- Right-side: Progress and Location
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
            inactive_sections = {
                -- Use full path for inactive filename to better identify the buffer
                lualine_c = { { 'filename', path = 2 } },
                lualine_x = { 'location' },
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            -- Remove winbar as filename is in the statusline
            winbar = {},
            inactive_winbar = {},
            extensions = { 'nvim-tree', 'fugitive', 'lazy', 'trouble', 'quickfix', 'toggleterm' },
        }
    end,
}
