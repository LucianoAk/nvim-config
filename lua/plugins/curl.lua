return {
	{
		"oysandvik94/curl.nvim",
		cmd = { "CurlOpen" },
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
		config = function()
			local curl = require("curl")
			curl.setup({})

			vim.keymap.set("n", "<leader>rc", function()
				curl.open_curl_tab()
			end, { desc = "Open a curl tab scoped to the current working directory" })

			vim.keymap.set("n", "<leader>ro", function()
				curl.open_global_tab()
			end, { desc = "Open a curl tab with global scope" })

			vim.keymap.set("n", "<leader>rsc", function()
				curl.create_scoped_collection()
			end, { desc = "Create or open a collection with a name from user input" })

			vim.keymap.set("n", "<leader>rgc", function()
				curl.create_global_collection()
			end, { desc = "Create or open a global collection with a name from user input" })

			vim.keymap.set("n", "<leader>rfsc", function()
				curl.pick_scoped_collection()
			end, { desc = "Choose a scoped collection and open it" })

			vim.keymap.set("n", "<leader>rfgc", function()
				curl.pick_global_collection()
			end, { desc = "Choose a scoped collection and open it" })
		end,
	},
}
