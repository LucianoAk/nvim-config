-- Automatically hide terminal buffers from the bufferline
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.bo.buflisted = false
	end,
})

-- Update the tabline visibility whenever the buffer list changes
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter" }, {
	callback = function()
		vim.opt.showtabline = Bufferline.get_bufferline_visibility()
	end,
})

-- Set buffer-local keymaps when an LSP client attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
			buffer = args.buf,
			desc = "Go to declaration",
		})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = args.buf,
			desc = "Go to definition",
		})
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {
			buffer = args.buf,
			desc = "Show hover documentation",
		})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
			buffer = args.buf,
			desc = "Go to implementation",
		})
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
			buffer = args.buf,
			desc = "Rename symbol",
		})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
			buffer = args.buf,
			desc = "Code actions",
		})
		vim.keymap.set("n", "gr", vim.lsp.buf.references, {
			buffer = args.buf,
			desc = "Find references",
		})
		vim.keymap.set({ "n", "v" }, "<leader>rx", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "refactor.extract" },
					diagnostics = {},
				},
			})
		end, {
			buffer = args.buf,
			desc = "Extract refactor",
		})
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
			buffer = args.buf,
			desc = "Show diagnostic details",
		})
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, {
			buffer = args.buf,
			desc = "Go to previous diagnostic",
		})
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, {
			buffer = args.buf,
			desc = "Go to next diagnostic",
		})
	end,
})
