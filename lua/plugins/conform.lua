return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					java = { "google-java-format" },
					xml = { "xmlformatter" },
					c = { "clang-format" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({ async = true, lsp_fallback = true })
			end, { desc = "Format file or range" })
		end,
	},
}
