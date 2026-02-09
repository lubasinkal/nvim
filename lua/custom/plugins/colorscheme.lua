return {
	"vague-theme/vague.nvim",
	lazy = false,
	config = function()
		-- NOTE: you do not need to call setup if you don't want to.
		require("vague").setup({
			-- optional configuration here
			transparent = true,
		})
		vim.cmd("colorscheme vague")
	end,
}
