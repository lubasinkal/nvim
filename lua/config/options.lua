vim.g.have_nerd_font = true

vim.opt.signcolumn = 'yes'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.scrolloff = 10
vim.opt.smoothscroll = true
vim.opt.sidescrolloff = 8
vim.opt.fillchars:append { eob = ' ', diff = '╱' }
vim.opt.inccommand = 'split'
vim.o.winborder = 'rounded'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.splitkeep = 'screen'
vim.opt.virtualedit = 'block'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.formatoptions:remove { 'c', 'r', 'o' }

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shada = "!,'100,<50,s10,h"

vim.opt.whichwrap:append '<>[]hl'
vim.opt.iskeyword:append '-'

vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40
vim.o.completeopt = 'menu,menuone,noselect,nearest'
vim.opt.pumheight = 10
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildoptions = 'pum'

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e1e' })

vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many', header = '' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
        on_jump = function(diag, bufnr)
            if diag then
                vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
            end
        end,
    },
})
