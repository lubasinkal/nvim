return {
  'linux-cultist/venv-selector.nvim',
  ft = 'python',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
    {
      'mfussenegger/nvim-dap-python',
      ft = 'python',
    },
    {
      'mfussenegger/nvim-dap',
      ft = 'python',
    },
  },
  opts = {
    auto_refresh = false,
    parents = 1,
    name = { 'venv', '.venv' },
  },
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = 'Select Python venv' },
    { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = 'Use cached venv' },
  },
  config = function(_, opts)
    require('venv-selector').setup(opts)

    -- Auto select cached venv on VimEnter if pyproject.toml exists
    vim.api.nvim_create_autocmd('VimEnter', {
      desc = 'Auto select virtualenv on Nvim open',
      pattern = '*',
      callback = function()
        local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
        if venv ~= '' then
          require('venv-selector').retrieve_from_cache()
        end
      end,
      once = true,
    })
  end,
}
