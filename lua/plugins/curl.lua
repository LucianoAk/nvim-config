return {
	{
		"oysandvik94/curl.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = "curl",
		init = function()
			vim.filetype.add({
				extension = {
					curl = "curl",
				},
			})
		end,
		config = true,
	},
}
