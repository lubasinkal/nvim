return {
	"vague-theme/vague.nvim",
	event = "VeryLazy",
	config = function()
		require("vague").setup({ transparent = true })
		vim.cmd("colorscheme vague")

		-- Defer statusline activation one more tick
		vim.schedule(function()
			require("custom.statusline").apply_highlights()
			vim.o.statusline = "%!v:lua.statusline()"
			vim.cmd("redrawstatus!")
		end)
	end,
}
