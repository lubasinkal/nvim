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
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    {
      '<leader>n',
      function()
        Snacks.picker.notifications() -- Keeping this as it's specific to Snacks notifications
      end,
      desc = 'Notification History',
    },
    -- NOTE: Most finder-related keymaps have been removed in favor of Telescope.
    -- Snacks is now primarily used for its UI features (dashboard, notifier, zen mode)
    -- and its excellent Git integration.
    {
      '<leader>fp',
      function()
        Snacks.picker.projects() -- Keeping projects picker
      end,
      desc = 'Projects',
    },
    -- git (Keeping all git-related pickers as they are a great alternative)
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
    -- Pickers for Neovim internals
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds() -- Keeping autocmds picker
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands() -- Keeping commands picker
      end,
      desc = 'Commands',
    },
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
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist() -- Keeping location list picker
      end,
      desc = 'Location List',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man() -- Keeping man pages picker
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist() -- Keeping quickfix list picker
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo() -- Keeping undo history picker
      end,
      desc = 'Undo History',
    },
    -- LSP Functionality is handled by Telescope and lspconfig keymaps
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
