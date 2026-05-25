vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

require('mini.comment').setup()
require('mini.notify').setup {
    lsp_progress = { enable = false },
    window = { winblend = 100 },
}
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.ai').setup {
    mappings = {
        around_next = 'aa',
        inside_next = 'ii',
    },
    n_lines = 500,
}
require('mini.surround').setup {
    mappings = {
        add = 'gsa', delete = 'gsd', replace = 'gsr',
        find = 'gsf', find_left = 'gsF', highlight = 'gsh',
        update_n_lines = 'gsn',
    },
    n_lines = 500,
}

local statusline = require('mini.statusline')
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function() return '%2l:%-2v' end
