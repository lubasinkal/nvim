return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Enable core modules
    animate = { enabled = true },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    layout = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    terminal = { enabled = true },
    toggle = { enabled = true },
    scratch = { enabled = true },
    profiler = { enabled = true },
    zen = { enabled = true },

    -- Dashboard customization
    dashboard = {
      preset = {
        pick = nil,
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':lua Snacks.picker.recent()' },
          { icon = ' ', key = 'g', desc = 'Grep Text', action = ':lua Snacks.picker.live_grep()' },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
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
      example = 'github',
      sections = {
        { section = 'header', hl = 'SpecialKey' },
        { section = 'keys', padding = 1 },
        { section = 'startup' },
      },
    },

    -- Explorer tweaks
    explorer = {
      live_search = true,
      follow_file = true,
      auto_close = false,
      focus = 'list',
      move_swap = { live = true },
      layout = { layout = { position = 'left' } },
      win = {
        list = {
          keys = { ['m'] = 'explorer_move' },
        },
      },
    },

    -- Animation & scroll tuning
    animate = {
      enabled = vim.g.snacks_animate ~= false,
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 10, total = 100 },
        easing = 'linear',
      },
      animate_repeat = {
        delay = 50,
        duration = { step = 3, total = 20 },
        easing = 'linear',
      },
    },

    -- Scope customization
    scope = {
      keys = {
        textobject = {
          ii = { min_size = 2, edge = false, cursor = false },
        },
      },
    },

    -- Image support (new in v2.16+)
    image = {
      enabled = true,
      hover = true,
      img_dirs = { 'images', 'assets' },
      formats = { 'png', 'jpg', 'gif', 'svg', 'pdf' },
      conceal = false,
    },

    -- Notifier defaults
    notifier = {
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.25 },
      padding = true,
      sort = { 'level', 'added' },
      level = vim.log.levels.INFO,
      style = 'compact',
      keep = function(n)
        return vim.fn.getcmdpos() > 0
      end,
    },
  },

  keys = {
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss Notifications',
    },
    {
      '<leader><space>',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find File',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.grep {
          prompt = ' ',
          search = '^\\s*- \\[ \\]',
          regex = true,
          live = false,
          dirs = { vim.fn.getcwd() },
          args = { '--no-ignore' },
          finder = 'grep',
          layout = 'ivy',
        }
      end,
      desc = 'Search TODOs',
    },
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches { layout = 'select' }
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log { layout = 'vertical' }
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff Hunks',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Browse in Browser',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    -- toggles example
    {
      '<leader>uz',
      function()
        Snacks.toggle.zen():toggle()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<leader>uD',
      function()
        Snacks.toggle.dim():toggle()
      end,
      desc = 'Toggle Dim',
    },
    {
      '<leader>ua',
      function()
        Snacks.toggle.animate():toggle()
      end,
      desc = 'Toggle Animation',
    },
    {
      '<leader>uS',
      function()
        Snacks.toggle.scroll():toggle()
      end,
      desc = 'Toggle Scroll',
    },
    {
      '<leader>ug',
      function()
        Snacks.toggle.indent():toggle()
      end,
      desc = 'Toggle Indent Guides',
    },
    -- words navigation
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1, true)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1, true)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
  },

  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        -- Auto-enable spell & wrap in text buffers
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'markdown', 'text', 'gitcommit' },
          callback = function()
            vim.wo.spell = true
            vim.wo.wrap = true
          end,
        })

        -- Startup notification
        vim.schedule(function()
          local stats = require('lazy').stats()
          Snacks.notify(string.format('Loaded %d/%d plugins in %.2fms', stats.loaded, stats.count, stats.startuptime), { title = 'Startup', icon = '🚀' })
        end)
      end,
    })
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.supports_method 'textDocument/inlayHint' then
          Snacks.toggle.inlay_hints():map('<leader>uh', { buffer = args.buf })
        end
      end,
    })
  end,
}
