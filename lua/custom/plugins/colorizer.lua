return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = { -- set to setup table
    filetypes = {
      'css',
      'scss',
      'html',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
      'svelte',
      'astro',
      'tailwindcss', -- Add Tailwind CSS filetype
    },
    user_default_options = {
      tailwind = true, -- Enable Tailwind CSS support
    },
  },
}
