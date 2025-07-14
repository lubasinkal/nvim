return {
  'rmagatti/auto-session',
  cmd = { 'SessionRestore', 'SessionSave' },
  keys = {
    { '<leader>wr', '<cmd>SessionRestore<CR>', desc = 'Session Restore' },
    { '<leader>ws', '<cmd>SessionSave<CR>', desc = 'Save session' },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    allowed_dirs = { '~/dev/*' },
    auto_restore = false,
    -- The following are already the default values, no need to provide them if these are already the settings you want.
    session_lens = {
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { 'i', '<C-D>' },
        alternate_session = { 'i', '<C-S>' },
        copy_session = { 'i', '<C-Y>' },
      },

      picker_opts = {
        border = true,
        layout_config = {
          width = 0.8, -- Can set width and height as percent of window
          height = 0.5,
        },
      },
    },
  },
}
