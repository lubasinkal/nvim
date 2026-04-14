return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
    cmd = { 'TSUpdate' },
    branch = 'main',
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end
                vim.treesitter.start(buf, lang)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
