return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"roobert/tailwindcss-colorizer-cmp.nvim",
			config = function()
				require("tailwindcss-colorizer-cmp").setup({
					color_square_width = 2,
				})
			end,
		},
	},

	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-k>"] = { "select_next", "fallback" },
			["<C-j>"] = { "select_prev", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			-- prefer explicit accept key (C-y) to reduce accidental accepts with <CR>
			["<C-y>"] = { "accept", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			-- Tab / S-Tab: sensible fallbacks, snippet support, complete when appropriate
			["<Tab>"] = {
				function(cmp)
					-- If popup visible, select next
					if cmp.is_visible() then
						return cmp.select_next()
					end
					-- If snippet engine has jump available, jump
					if cmp.snippet_active() then
						return cmp.snippet_forward()
					end
				end,
				"fallback",
			},

			["<S-Tab>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.select_prev()
					end
					if cmp.snippet_active() then
						return cmp.snippet_backward()
					end
					return cmp.fallback()
				end,
				"fallback",
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},

		signature = { enabled = true },
		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			-- menu rendering and components
			menu = {
				border = "rounded",
				draw = {
					padding = 1,
					gap = 1,
					columns = {
						{ "label", gap = 1 },
						{ "kind_icon" },
						{ "source_name" },
					},
					components = {
						source_name = {
							text = function(ctx)
								local source_display_names = {
									lsp = "[lsp]",
									path = "[path]",
									snippets = "[snip]",
									buffer = "[buf]",
								}
								return source_display_names[ctx.source_name] or string.format("[%s]", ctx.source_name)
							end,
						},
						kind_icon = {
							text = function(ctx)
								return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
