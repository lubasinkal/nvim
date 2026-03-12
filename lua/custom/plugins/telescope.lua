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
        elseif vim.fn.executable 'make' == 1 then
          return 'make'
        else
          return nil -- Skip build, will use Lua fallback
        end
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
  },
  keys = {
    -- Search (prefixed with leader s)
    { '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = '[S]earch [H]elp' },
    { '<leader>sk', '<cmd>Telescope keymaps<CR>', desc = '[S]earch [K]eymaps' },
    { '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = '[S]earch current [W]ord' },
    { '<leader>sg', '<cmd>Telescope live_grep<CR>', desc = '[S]earch by [G]rep' },
    { '<leader>sd', '<cmd>Telescope diagnostics<CR>', desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', '<cmd>Telescope resume<CR>', desc = '[S]earch [R]esume' },
    { '<leader>s.', '<cmd>Telescope oldfiles<CR>', desc = '[S]earch Recent Files' },
    { '<leader>ss', '<cmd>Telescope builtin<CR>', desc = '[S]earch [S]elect Telescope' },
    { '<leader>sf', '<cmd>Telescope find_files<CR>', desc = '[S]earch [F]iles' },
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Git
    { '<leader>gf', '<cmd>Telescope git_files<CR>', desc = '[G]it [F]iles' },
    { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = '[G]it [C]ommits' },
    { '<leader>gC', '<cmd>Telescope git_bcommits<CR>', desc = '[G]it [B]uffer [C]ommits' },
    { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = '[G]it [B]ranches' },
    { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = '[G]it [S]tatus' },
    -- Buffers (prefixed with leader b)
    { '<leader>bb', '<cmd>Telescope buffers<CR>', desc = '[B]uffer List' },
    { '<leader>br', '<cmd>Telescope oldfiles<CR>', desc = '[B]uffer [R]ecent' },
    { '<leader>bm', '<cmd>Telescope marks<CR>', desc = '[B]uffer [M]arks' },
    { '<leader>bd', '<cmd>bdelete<CR>', desc = '[B]uffer [D]elete current' },
  },
  config = function()
    local actions = require 'telescope.actions'

    require('telescope').setup {
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
          },
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
          n = {
            ['q'] = actions.close,
            ['dd'] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        -- find_files = { hidden = true },
        buffers = {
          sort_lastused = true,
          theme = 'dropdown',
          previewer = false,
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
  end,
}
