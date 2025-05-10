return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = { 'VimEnter' }, -- Consider 'VimEnter' if you use telescope early
  cmd = 'Telescope', -- Load on the first use of the Telescope command
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    -- Uncomment the next line if you have a Nerd Font and want icons
    -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'
    local layout = require('telescope.themes').get_dropdown()

    telescope.setup {
      -- You can put your default mappings / updates / etc. in here
      -- All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        -- Mappings for Telescope
        mappings = {
          i = {
            ['<C-n>'] = actions.move_selection_next, -- Move to the next item in insert mode
            ['<C-p>'] = actions.move_selection_previous, -- Move to the previous item in insert mode
            ['<C-u>'] = actions.preview_scrolling_up, -- Scroll preview up
            ['<C-d>'] = actions.preview_scrolling_down, -- Scroll preview down
            ['<C-c>'] = actions.close, -- Close Telescope
            -- ['<C-/>'] = actions.whatis, -- Show keymaps for the current picker
            -- ['<C-j>'] = actions.move_selection_next, -- Alias for C-n
            -- ['<C-k>'] = actions.move_selection_previous, -- Alias for C-p
          },
          n = {
            ['<C-n>'] = actions.move_selection_next, -- Move to the next item in normal mode
            ['<C-p>'] = actions.move_selection_previous, -- Move to the previous item in normal mode
          },
        },
        -- General options for all pickers
        layout_strategy = 'horizontal', -- or 'vertical', 'flex', 'center'
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          -- customize any layout config here
        },
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_ignore_patterns = { '%.git/', 'node_modules/' }, -- Ignore some common directories
        -- path_display = { 'truncate' }, -- How to display file paths
        -- winblend = 0, -- Transparency of the Telescope window
        -- border = {}, -- Border for the Telescope window
        -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        -- color_icons = true, -- Use colors for icons (requires nvim-web-devicons)
      },
      pickers = {
        -- Default configuration for specific pickers
        find_files = {
          -- Set to true to show hidden files
          show_hidden = true,
          -- Other options for find_files
        },
        live_grep = {
          -- Other options for live_grep
        },
        -- You can configure any built-in picker here
        -- See `:help telescope.builtin` for a list of pickers
      },
      extensions = {
        ['ui-select'] = {
          -- Configuration for ui-select extension
          -- You can use a different theme if you prefer
          require('telescope.themes').get_dropdown(),
          -- require('telescope.themes').get_cursor(),
          -- require('telescope.themes').get_ivy(),
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
          },
        },
        -- Other extensions can be configured here
      },
    }

    -- Enable Telescope extensions if they are installed
    -- This is already in your config, just ensuring it's here
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- [[ Telescope Keymaps ]]
    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Find files in the current git repository
    vim.keymap.set('n', '<leader>sF', function()
      builtin.find_files { cwd = vim.fn.getcwd() }
    end, { desc = '[S]earch [F]iles (cwd)' })

    -- Search for a string in the current working directory
    vim.keymap.set('n', '<leader>sG', function()
      builtin.live_grep { cwd = vim.fn.getcwd() }
    end, { desc = '[S]earch by [G]rep (cwd)' })

    -- Command history
    if builtin.command_history then
      vim.keymap.set('n', '<leader>s:', builtin.command_history, { desc = '[S]earch [:] Command History' })
    end

    -- Search marks
    if builtin.marks then
      vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
    end

    -- Search registers
    if builtin.registers then
      vim.keymap.set('n', '<leader>sp', builtin.registers, { desc = '[S]earch [P]aste Registers' }) -- using 'p' for paste
    end

    -- Search jumplist
    if builtin.jumplist then
      vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S]earch [J]umplist' })
    end

    -- Search themes (requires telescope-ui-select)
    vim.keymap.set('n', '<leader>sc', function()
      builtin.colorscheme { enable_preview = true }
    end, { desc = '[S]earch [C]olourscheme' })

    --
    -- File browser (requires a file browser extension like telescope-file-browser.nvim)
    -- If you install telescope-file-browser, uncomment the following and add it to dependencies:
    -- { 'nvim-telescope/telescope-file-browser.nvim' },
    -- pcall(telescope.load_extension, 'file_browser')
    -- if telescope.extensions.file_browser then -- Check if the extension is loaded
    --   vim.keymap.set('n', '<leader>sb', function()
    --     telescope.extensions.file_browser.file_browser()
    --   end, { desc = '[S]earch [B]rowser' })
    -- end

    -- Slightly advanced example of overriding default behavior and theme
    -- Keeping your existing mapping but applying the default layout from setup
    vim.keymap.set('n', '<leader>/', function()
      -- Use the default dropdown layout defined in telescope.setup()
      builtin.current_buffer_fuzzy_find(layout)
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- Keeping your existing mapping, also using the default layout
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
        -- Use the default dropdown layout defined in telescope.setup()
        -- theme = layout,
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    -- Keeping your existing mapping
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
