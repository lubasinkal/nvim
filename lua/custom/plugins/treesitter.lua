return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate', -- Command to run after installation/update
  event = { 'BufReadPre', 'BufNewFile' }, -- Load on BufReadPre or BufNewFile for lazy loading
  cmd = { 'TSUpdate' },
  main = 'nvim-treesitter.configs', -- Specify the main module for Lazy.nvim's opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
      'lua',
      -- Add other languages you work with frequently here
      -- 'c', 'cpp', 'java', 'ruby', 'rust', 'yaml', 'json', 'markdown',
    },

    -- Install languages that are not already installed above
    auto_install = true,

    -- Enable syntax highlighting
    highlight = {
      enable = true,
      -- NOTE: `false` will disable the whole extension
      -- Setting this to true will enable vivification for e.g. ruby and vetur
      additional_vim_regex_highlighting = false, -- Removed unnecessary additional_vim_regex_highlighting
    },

    -- Enable indentation
    indent = { enable = true, disable = { 'ruby' } }, -- Keep disable if needed

    -- Enable context commenting (e.g., `gc` to comment/uncomment blocks)
    context_commentstring = {
      enable = true,
      enable_autocmd = true, -- Set to true to automatically set commentstring based on filetype
    },
  },
}
