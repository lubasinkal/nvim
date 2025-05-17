return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false, -- Snacks is designed to load early
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        pick = nil,
        ---@type snacks.dashboard.Item[]
        header = [[
	                                                                     
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]],
      },
      sections = {
        { section = 'header' },
        { section = 'keys', padding = 1 },
        { section = 'startup' },
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
    },
    quickfile = {
      enabled = true,
    },
    scope = { enabled = true },
    scroll = { enabled = true },
    toggle = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- Top Pickers & Explorer
    -- Removed: '<leader><space>' (Snacks.picker.smart - overlaps with file finding)
    -- Removed: '<leader>,' (Snacks.picker.buffers - overlaps with Telescope)
    -- Removed: '<leader>/' (Snacks.picker.grep - overlaps with Telescope)
    -- Removed: '<leader>:' (Snacks.picker.command_history - overlaps with Telescope)
    {
      '<leader>n',
      function()
        Snacks.picker.notifications() -- Keeping this as it's specific to Snacks notifications
      end,
      desc = 'Notification History',
    },
    -- Removed: '<leader>e' (Snacks.explorer - overlaps with neotree)
    -- {
    --   '<leader>e',
    --   function()
    --     Snacks.explorer() -- Keeping the Snacks file explorer
    --   end,
    --   desc = 'File Explorer',
    -- },

    -- find
    -- Removed: '<leader>fb' (Snacks.picker.buffers - overlaps with Telescope)
    -- Removed: '<leader>fc' (Snacks.picker.files cwd config - overlaps with Telescope)
    -- Removed: '<leader>ff' (Snacks.picker.files - overlaps with Telescope)
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files() -- Keeping git files picker
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.projects() -- Keeping projects picker
      end,
      desc = 'Projects',
    },
    -- Removed: '<leader>fr' (Snacks.picker.recent - overlaps with Telescope)

    -- git (Keeping all git-related pickers as they seem specific to Snacks or complementary)
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },

    -- Grep
    -- Removed: '<leader>sb' (Snacks.picker.lines - duplicate and overlaps conceptually)
    -- Removed: '<leader>sB' (Snacks.picker.grep_buffers - overlaps with Telescope)
    -- Removed: '<leader>sg' (Snacks.picker.grep - overlaps with Telescope)
    -- Removed: '<leader>sw' (Snacks.picker.grep_word - overlaps with Telescope)

    -- search
    -- Removed: '<leader>s"' (Snacks.picker.registers - overlaps with Telescope)
    -- Removed: '<leader>s/' (Snacks.picker.search_history - overlaps with Telescope)
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds() -- Keeping autocmds picker
      end,
      desc = 'Autocmds',
    },
    -- Removed: '<leader>sb' (Snacks.picker.lines - duplicate and overlaps conceptually)
    -- Removed: '<leader>sc' (Snacks.picker.command_history - overlaps with Telescope)
    {
      '<leader>sC',
      function()
        Snacks.picker.commands() -- Keeping commands picker
      end,
      desc = 'Commands',
    },
    -- Removed: '<leader>sd' (Snacks.picker.diagnostics - overlaps with Telescope)
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics_buffer() -- Keeping buffer diagnostics (complementary to workspace diagnostics)
      end,
      desc = 'Buffer Diagnostics',
    },
    -- Removed: '<leader>sh' (Snacks.picker.help - overlaps with Telescope)
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights() -- Keeping highlights picker
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons() -- Keeping icons picker
      end,
      desc = 'Icons',
    },
    -- Removed: '<leader>sj' (Snacks.picker.jumps - overlaps with Telescope)
    -- Removed: '<leader>sk' (Snacks.picker.keymaps - overlaps with Telescope)
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist() -- Keeping location list picker
      end,
      desc = 'Location List',
    },
    -- Removed: '<leader>sm' (Snacks.picker.marks - overlaps with Telescope)
    {
      '<leader>sM',
      function()
        Snacks.picker.man() -- Keeping man pages picker
      end,
      desc = 'Man Pages',
    },
    -- Removed: '<leader>sp' (Snacks.picker.lazy - overlaps with Telescope 'registers')
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist() -- Keeping quickfix list picker
      end,
      desc = 'Quickfix List',
    },
    -- Removed: '<leader>sR' (Snacks.picker.resume - overlaps with Telescope)
    {
      '<leader>su',
      function()
        Snacks.picker.undo() -- Keeping undo history picker
      end,
      desc = 'Undo History',
    },
    -- Removed: '<leader>uC' (Snacks.picker.colorschemes - overlaps with Telescope themes)

    -- LSP (Keeping all LSP pickers as they seem specific to Snacks or complementary)
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },
    -- Other (Keeping these as they are not standard Telescope pickers)
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },
    -- {
    --   '<leader>.',
    --   function()
    --     Snacks.scratch()
    --   end,
    --   desc = 'Toggle Scratch Buffer',
    -- },
    -- {
    --   '<leader>S',
    --   function()
    --     Snacks.scratch.select()
    --   end,
    --   desc = 'Select Scratch Buffer',
    -- },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history() -- Duplicate with the '<leader>n' above, removing the first one is an option.
      end,
      desc = 'Notification History',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore', -- Assuming this is for which-key integration
    },
    -- Keeping these unless you have specific Telescope mappings for next/prev reference
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
      end,
    })
  end,
}
