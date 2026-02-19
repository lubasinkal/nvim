return {
	"catgoose/nvim-colorizer.lua",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		user_default_options = {
			tailwind = true, -- enables basic Tailwind color names (red-500 etc.)
			-- tailwind = "both",          -- if you also use tailwindcss LSP and want custom colors
			css = true, -- optional: enables #rrggbb, rgb(), hsl() etc.
			css_fn = true,
			mode = "background", -- or "foreground" / "virtualtext"
		},
	},
}
